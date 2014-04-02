draftin.comment = {
  postArticleComment: function(user_id, article_id, content_source){
    draftin.loading();
    content = encodeURIComponent($(content_source).val());
    $.ajax({type:"POST", url:'/api/v1/comments.json?comment[user_id]='+user_id+'&comment[article_id]='+article_id+'&comment[content]='+content,
      success: function(result){
        location.reload();
      }
    });
  },
  updateArticleComment: function(comment_id, content_source){
    draftin.loading();
    content = encodeURIComponent($(content_source).val());
    $.ajax({type:"PUT", url:'/api/v1/comments/'+comment_id+'.json?comment[content]='+content,
      success: function(result){
        location.reload();
      }
    });
  },
  destroyComment: function(comment_id){
    draftin.loading();
    $.ajax({type:"DELETE", url:'/api/v1/comments/'+comment_id+'.json',
      complete: function(result){
        location.reload();
      }
    });
  },
  initChatRoom: function(user_id, chat_room_id, last_post_id){
    draftin.comment.user_id = user_id;
    draftin.comment.chat_room_id = chat_room_id;
    draftin.comment.last_post_id = last_post_id;
    draftin.comment.initEnterKeypress();
    draftin.comment.scrollToBottomOfChatWindow();
    setTimeout(function(){ draftin.comment.chatRoomPolling(); }, 750);
  },
  chatRoomPolling: function(){
    chat_room_content = $('div#chat_room_content');
    $.ajax({type:"GET", url:'/api/v1/comments.json?chat_room_id='+draftin.comment.chat_room_id,
      statusCode:{404: function(response){location.reload();}},
      success: function(result){
        new_results = false;
        if(result.comments){
          $.each(result.comments, function(){
            if(this.id > draftin.comment.last_post_id){
              new_results = true;
              draftin.comment.last_post_id = this.id;
              $(chat_room_content).append('<p>'+
                draftin.comment.postTemplate.replace(/\{\{username\}\}/ig, this.username)
                .replace(/\{\{created_at\}\}/ig, this.created_at)
                .replace(/\{\{content\}\}/ig, this.content.replace(/<p>/i,''))
              );
              if(this.user_id != draftin.comment.user_id){
                if(!draftin.hasFocus){
                  draftin.ding.play();
                  $.titleAlert('New Messages...', {stopOnMouseMove:true, stopOnFocus:true, interval:1250});
                }
              }
            }
          });
          if(new_results){
            draftin.comment.scrollToBottomOfChatWindow();
          }
        }
        setTimeout(function(){ draftin.comment.chatRoomPolling(); }, 750);
      }
    });
  },
  initEnterKeypress: function(){
    $("input#chat_room_input").keypress(function(event){
      if(event.which == 13){
        event.preventDefault();
        draftin.comment.postChatRoomComment(draftin.comment.user_id, draftin.comment.chat_room_id);
      }
    });
  },
  postChatRoomComment: function(user_id, chat_room_id){
    draftin.loading();
    chat_room_button = $('button#chat_room_button');
    chat_room_input = $('input#chat_room_input');
    content = encodeURIComponent($(chat_room_input).val());
    if(content != undefined && content != "" && content != null){
      $(chat_room_button).addClass('disabled');
      $.ajax({type:"POST", url:'/api/v1/comments.json?comment[user_id]='+user_id+'&comment[chat_room_id]='+chat_room_id+'&comment[content]='+content,
        success: function(result){
          $(chat_room_input).val(null);
          $(chat_room_button).removeClass('disabled');
          draftin.loading();
        }
      });
    } else {
      draftin.loading();
    }
  },
  scrollToBottomOfChatWindow: function(){
    posts = $('div#chat_room_content')[0];
    posts.scrollTop = posts.scrollHeight;
  }
}

draftin.comment.postTemplate = '<div class="user_comment">'+
  '<span class="label label-default">{{username}} @{{created_at}}</span> {{content}}'+
'</div>';