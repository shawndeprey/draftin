draftin.draft = {
  init: function(draftId, draftStage){
    draftin.draft.id = draftId;
    if(draftStage == 0){ // Lobby/Setup Stage
      draftin.draft.lobby.init();
    } else
    if(draftStage == 1){
      draftin.draft.table.init();
    } else {
      console.log("Draft is over busta!");
    }
  },
  lobby: {
    init: function(){
      draftin.draft.userTemplate = '<li class="list-group-item user">{{username}}</li>';
      draftin.draft.setTemplate = '<li class="list-group-item">{{name}}<button type="button" class="btn btn-danger btn-xs" style="float:right;" onclick="draftin.draft.lobby.removeSet({{id}});">Remove</button></li>';
      setInterval(function(){ draftin.draft.lobby.polling(); }, 1000);
    },
    polling: function(){
      $.ajax({type:"GET", url:'/api/v1/drafts/'+draftin.draft.id+'.json',
        success: function(result){
          if(result.draft.stage == 0){
            draftin.draft.lobby.checkUsers(result.draft.users);
            draftin.draft.lobby.checkSets(result.draft.card_sets);
          } else {
            location.reload();
          }
        }
      });
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
      console.log("Draft is in progress busta brown!");
    }
  }
}
