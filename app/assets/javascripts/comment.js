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
  }
}
