# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $button = $('td button[obj=repo]')
  $button.click (event, data) ->
    repoId = $(this).data('repo-id')
    releaseId = $(this).data('release-id')

    $.post('/api/v1/repo/parse_dependency', {repoId: repoId, releaseId: releaseId},
      (response) ->
        if response.error_code == 0
          if false
            console.info('依赖解析中, repo_id: ' + repoId)
          else
            clickedEl = $(event.currentTarget)
            clickedEl.replaceWith('<td>依赖解析中</td>')
            console.info('依赖解析中, repo_id: ' + repoId)
    ,'json'
    )

  $buttonOneKey = $('button[obj=one_key]')
  $buttonOneKey.click (event, data) ->
    releaseId = $(this).data('release-id')
    $button.trigger('click')
    clickedEl = $(event.currentTarget)
    clickedEl.replaceWith('依赖解析中')
    console.info('依赖解析中, releaseId: ' + releaseId)
