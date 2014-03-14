draftin.draft = {
  init: function(draftId, draftStage){
    draftin.draft.id = draftId;
    draftin.draft.poll = true;
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
      draftin.draft.setTemplate = '<li class="list-group-item">{{name}}<button type="button" class="btn btn-danger btn-xs" style="float:right;" onclick="draftin.draft.lobby.removeSet({{id}});">Remove</button></li>';
      $('button.start_button').parent().tooltip();
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
            location.reload();
          }
        }
      });
    },
    checkStartConditions: function(users){
      startButton = $('button.start_button');
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
    },
    checkUsers: function(users){
      userContainer = $('div#draft_users ul.list-group');
      userCount = userContainer.children().length - 1;
      if(users.length != userCount){
        $(userContainer).find('li.user').remove();
        $.each(users, function(){
          $(userContainer).append(draftin.draft.userTemplate.replace(/\{\{username\}\}/i,this.username));
        });
      }
    },
    checkSets: function(sets){
      setContainer = $('div#set_container');
      setCount = setContainer.children().length;
      if(sets.length != setCount){
        $(setContainer).find('li').remove();
        $.each(sets, function(){
          $(setContainer).append(draftin.draft.setTemplate.replace(/\{\{name\}\}/i,this.name).replace(/\{\{id\}\}/i,this.id));
        });
      }
    },
    addSet: function(){
      setContainer = $('li#add_set_container');
      setId = $(setContainer).find('select').val();
      $.ajax({type:"POST", url:'/api/v1/drafts/'+draftin.draft.id+'/card_sets/'+setId+'.json'});
    },
    removeSet: function(setId){
      $.ajax({type:"DELETE", url:'/api/v1/drafts/'+draftin.draft.id+'/card_sets/'+setId+'.json'});
    },
    startDraft: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/start.json'});
    }
  },
  table: { // Like you're at the table...shutup...
    init: function(){
      draftin.draft.cardTemplate = '<div class="col-sm-3 card_box" data-mid="{{mid}}"><img src="{{image_url}}" class="card"></div>';
      draftin.draft.table.setClickEvents();
      $('button.next_button').parent().tooltip();
      
        setTimeout(function(){ draftin.draft.table.polling(); }, 750);
    },
    polling: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/status.json',
        statusCode:{404: function(response){location.reload();}},
        success: function(result){
          if(result.draft.stage == 1){
            draftin.draft.table.updateUserPackCounts(result.draft.users, result.draft.card_sets);
            draftin.draft.table.updateCurrentPack(result.draft.current_pack);
            if(draftin.draft.poll){
              setTimeout(function(){ draftin.draft.table.polling(); }, 750);
            } else {
              $('div.finish_col').show();
              $('div.user_col').hide();
              $('div.current_pack_col').hide();
            }
          } else {
            location.reload();
          }
        }
      });
    },
    nextPack: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/next_pack.json'});
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

      // End The Draft
      if(allCountsZero && card_sets.length == 0){
        draftin.draft.poll = false;
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
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'/select_card.json?multiverse_id='+$(card).data('mid'),
        success: function(result){
          if(result && result.success){
            draftin.draft.table.removeSelectedStatusFromAll();
            $(card).off('click').removeClass('card_box');
            draftin.draft.table.clearCurrentPack();
            $('div#cards_container').prepend(card);
          }
        }
      });
    }
  }
}
