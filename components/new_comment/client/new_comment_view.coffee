_ = require 'underscore'
Backbone = require "backbone"
Backbone.$ = $
Comment = require "../../../models/comment.coffee"
mediator = require '../../../lib/mediator.coffee'
sd = require("sharify").data
analytics = require '../../../lib/analytics.coffee'

newCommentTemplate = -> require('../templates/new_comment.jade') arguments...

module.exports = class NewCommentView extends Backbone.View

  events:
    'click .new-comment__submit': 'addComment'

  initialize: (options)->
    @block_id = options.block_id
    @render() if options.autoRender

  fieldIsEmpty: -> @$input.val() is ""

  addComment: ->
    if not @fieldIsEmpty()
      userAttrs = _.pick(mediator.shared.current_user.attributes, ['slug', 'username', 'avatar', 'id'])

      comment = new Comment
        body: @$input.val()
        user: userAttrs
        created_at: new Date()
      , block_id: @block_id

      @$input.attr "disabled", "disabled"

      comment.save {},
        success: =>
          analytics.track.click "Comment added"
          @$input.removeAttr 'disabled'
          @$input.val ""
          mediator.trigger 'new:comment', comment

  render: ->
    @$el.html newCommentTemplate()
    @$input = @$('textarea.new-comment__field')
