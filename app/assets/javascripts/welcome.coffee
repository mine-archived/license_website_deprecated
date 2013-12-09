# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $button = $('td button[obj=repo]')
  $button.click (event, data) ->
    repoId = $(this).data('repo-id')
#    force = $(this).data('force')

    $.post('/api/v1/repo/parse_dependency', {repoId: repoId},
      (response) ->
#        console.log(response)
        if response.error_code == 0
#          if force
          if false
            console.info('依赖解析中, repo_id: ' + repoId)
          else
            clickedEl = $(event.currentTarget)
            clickedEl.replaceWith('<td>依赖解析中</td>')
            console.info('依赖解析中, repo_id: ' + repoId)
      ,'json'
    )

  $btnExport = $('#btnExport')
  $btnExport.click (event, data) ->
    $formExport = $('#formExportZip')
    $formExport.submit()

  $btnEnqueueAll = $('#btnEnqueueAll')
  $btnEnqueueAll.click (event, data) ->
    repoId = $(this).data('repo-id')
    $.post('/api/v1/repo/enqueue_all_repo', {repoId: repoId},
      (response) ->
#        console.log(response)
        if response.error_code == 0
          if force
            console.info('依赖解析中, repo_id: ' + repoId)
          else
#            clickedEl = $(event.currentTarget)
#            clickedEl.replaceWith('<td>依赖解析中</td>')
    ,'json'
    )

