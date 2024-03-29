draftin.draft = {
  init: function(draftId, draftStage, sessionUserId, coordinatorId){
    draftin.draft.id = draftId;
    draftin.draft.user_id = sessionUserId;
    draftin.draft.coordinator_id = coordinatorId;
    draftId = $('span#draft_id');
    if(draftId.length > 0){
      $(draftId).tooltip();
    }
    if(draftStage == 0){ // Lobby/Setup Stage
      draftin.draft.lobby.init();
    } else
    if(draftStage == 1){
      draftin.draft.table.init();
    }
  },
  lobby: {
    init: function(){
      draftin.draft.userTemplate = '<li class="list-group-item user">{{username}}</li>';
      draftin.draft.userAdminTemplate = '<li class="list-group-item user">{{username}}<button type="button" class="btn btn-danger btn-xs" style="float:right;" onclick="draftin.draft.lobby.kickUser({{id}});">Kick</button></li>';
      draftin.draft.setTemplate = '<li class="list-group-item">{{name}}</li>';
      draftin.draft.setTemplateAdmin = '<li class="list-group-item">{{name}}<button type="button" class="btn btn-danger btn-xs" style="float:right;" onclick="draftin.draft.lobby.removeSet({{id}});">Remove</button></li>';
      startButton = $('button.start_button');
      if(startButton.length > 0){
        $(startButton).parent().tooltip();
      }
      draftin.draft.lobby.setMaxUsersCallback();
      setTimeout(function(){ draftin.draft.lobby.polling(); }, 750);
    },
    polling: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'.json',
        statusCode:{404: function(response){location.reload();}},
        success: function(result){
          if(result.draft.stage == 0){
            draftin.draft.lobby.checkUsers(result.draft.users);
            draftin.draft.lobby.checkSets(result.draft.card_sets);
            draftin.draft.lobby.checkStartConditions(result.draft.users);
            setTimeout(function(){ draftin.draft.lobby.polling(); }, 750);
          } else {
            draftin.alert("Draft Starting...");
            location.reload();
          }
        }
      });
    },
    setMaxUsersCallback: function(){
      $('select#max_user_count').off('change').on('change', function(){
        draftin.loading();
        $.ajax({
          type:"PUT", url:'/api/v1/drafts/'+draftin.draft.id+'.json?_method=PUT&draft[max_users]='+$(this).val(), 
          complete: function(data){
            draftin.loading();
          }
        });
      });
    },
    kickUser: function(user_id){
      draftin.loading();
      $.ajax({
        type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/users/'+user_id+'/kick.json', 
        complete: function(data){
          draftin.loading();
        }
      });
    },
    checkStartConditions: function(users){
      startButton = $('button.start_button');
      if(startButton.length > 0){
        if(users.length > 1){
          if($(startButton).hasClass('disabled')){
            $(startButton).removeClass('disabled');
            $(startButton).parent().tooltip('disable');
          }
        } else {
          if(!$(startButton).hasClass('disabled')){
            $(startButton).addClass('disabled');
            $(startButton).parent().tooltip('enable');
          }
        }
      }
    },
    checkUsers: function(users){
      userContainer = $('div#draft_users ul.list-group');
      userCount = userContainer.children().length - 1;
      containsSessionUser = false;
      if(users.length != userCount){
        draftin.alert("Users Updated...");
        $(userContainer).find('li.user').remove();
        $.each(users, function(){
          if(this.id == draftin.draft.user_id){
            containsSessionUser = true;
          }
          if(draftin.draft.user_id == draftin.draft.coordinator_id) {
            $(userContainer).append(draftin.draft.userAdminTemplate
              .replace(/\{\{username\}\}/ig,this.username)
              .replace(/\{\{id\}\}/ig,this.id)
            );
          } else {
            $(userContainer).append(draftin.draft.userTemplate.replace(/\{\{username\}\}/i,this.username));
          }
        });
        if(!containsSessionUser){
          location.reload();
        }
      }
    },
    checkSets: function(sets){
      setContainer = $('div#set_container');
      setCount = setContainer.children().length;
      if(sets.length != setCount){
        draftin.alert("Sets Updated...");
        $(setContainer).find('li').remove();
        $.each(sets, function(){
          if(draftin.draft.user_id == draftin.draft.coordinator_id) {
            $(setContainer).append(draftin.draft.setTemplateAdmin.replace(/\{\{name\}\}/i,this.name).replace(/\{\{id\}\}/i,this.id));
          } else {
            $(setContainer).append(draftin.draft.setTemplate.replace(/\{\{name\}\}/i,this.name));
          }
        });
      }
    },
    addSet: function(){
      setContainer = $('li#add_set_container');
      setId = $(setContainer).find('select').val();
      if(setId != ""){
        draftin.loading();
        $.ajax({
          type:"POST", url:'/api/v1/drafts/'+draftin.draft.id+'/card_sets/'+setId+'.json', 
          complete: function(data){
            draftin.loading();
          }
        });
      }
    },
    removeSet: function(setId){
      draftin.loading();
      $.ajax({
        type:"DELETE", url:'/api/v1/drafts/'+draftin.draft.id+'/card_sets/'+setId+'.json', 
        complete: function(data){
          draftin.loading();
        }
      });
    },
    startDraft: function(){
      draftin.loading();
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/start.json'});
    }
  },
  table: { // Like you're at the table...shutup...
    init: function(){
      draftin.draft.cardTemplate = '<div class="col-sm-3 card_box" data-mid="{{mid}}"><img src="{{image_url}}" class="card"></div>';
      draftin.draft.table.setClickEvents();
      nextButton = $('button.next_button');
      if(nextButton.length > 0){
        $(nextButton).parent().tooltip();
      }
      setTimeout(function(){ draftin.draft.table.polling(); }, 750);
    },
    polling: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/status.json',
        statusCode:{404: function(response){location.reload();}},
        success: function(result){
          if(result.draft.stage == 1){
            draftin.draft.table.updateUserPackCounts(result.draft.users, result.draft.card_sets);
            draftin.draft.table.updateCurrentPack(result.draft.current_pack);
            setTimeout(function(){ draftin.draft.table.polling(); }, 750);
          } else {
            draftin.alert("Draft Ending...");
            location.reload();
          }
        }
      });
    },
    nextPack: function(){
      draftin.loading();
      $.ajax({
        type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/next_pack.json',
        complete: function(result){
          draftin.loading();
        }
      });
    },
    updateUserPackCounts: function(users, card_sets){
      allCountsZero = true;
      nextButton = $('button.next_button');
      $.each(users, function(){
        if(this.pack_count != 0){
          allCountsZero = false;
        }
        counter = $('span.user_'+this.id+'_packs');
        if(counter){
          $(counter).html(this.pack_count);
        }
      });
      if(nextButton.length > 0){
        if(allCountsZero && card_sets.length != 0){
          if($(nextButton).hasClass('disabled')){
            $(nextButton).removeClass('disabled');
            $(nextButton).parent().tooltip('disable');
          }
        } else {
          if(!$(nextButton).hasClass('disabled')){
            $(nextButton).addClass('disabled');
            $(nextButton).parent().tooltip('enable');
          }
        }
      }

      // End The Draft
      if(allCountsZero && card_sets.length == 0){
        if(users[0].id == draftin.draft.user_id){
          $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/end_draft.json'});
        }
      }
    },
    updateCurrentPack: function(currentPack){
      currentPackContainer = $('div#current_pack_container');
      loadingMessage = $('div#pack_loading_message');
      if(currentPack != null && $(currentPackContainer).children().length == 0){
        $(loadingMessage).hide();
        $.each(currentPack.cards, function(){
          $(currentPackContainer).append(draftin.draft.cardTemplate.replace(/\{\{mid\}\}/i,this.multiverseid).replace(/\{\{image_url\}\}/i,this.image_url));
        });
        draftin.draft.table.setClickEvents();
        draftin.alert("New Pack...");
      } else {
        if($(currentPackContainer).children().length == 0 && !$(loadingMessage).is(":visible")){
          $(loadingMessage).show();
        }
      }
    },
    setClickEvents: function(){
      $('div#current_pack_container').children().off('click').on('click', function(){
        draftin.draft.table.selectCard(this);
      });
    },
    removeSelectedStatusFromAll: function(){
      $('div#current_pack_container').children().removeClass('selected');
    },
    clearCurrentPack: function(){
      $('div#current_pack_container').children().remove();
      $('div#pack_loading_message').show();
    },
    selectCard: function(card){
      if($(card).hasClass('selected')){
        draftin.draft.table.selectMultiverseIdFromCurrentPack(card);
      } else {
        draftin.draft.table.removeSelectedStatusFromAll();
        $(card).addClass('selected');
      }
    },
    selectMultiverseIdFromCurrentPack: function(card){
      draftin.loading();
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/select_card.json?multiverse_id='+$(card).data('mid'),
        success: function(result){
          if(result && result.success){
            draftin.draft.table.removeSelectedStatusFromAll();
            $(card).off('click').removeClass('card_box').addClass('card_container');
            draftin.draft.table.clearCurrentPack();
            $('div#cards_container').prepend(card);
          }
          draftin.loading();
        }
      });
    }
  }
}
