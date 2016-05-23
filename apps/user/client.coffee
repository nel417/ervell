#
# The client-side code for a User Profile
#

Backbone = require "backbone"
Backbone.$ = $
_ = require 'underscore'
scrollFrame = require 'scroll-frame'
sd = require("sharify").data
mediator = require '../../lib/mediator.coffee'
User = require "../../models/user.coffee"
UserBlocks = require '../../collections/user_blocks.coffee'
FollowBlocks = require '../../collections/follow_blocks.coffee'
InfiniteView = require '../../components/pagination/infinite_view.coffee'
Filter = require '../../components/filter/index.coffee'
PathView = require '../../components/path/client/path_view.coffee'
MetaEditableAttributeView = require '../../components/editable_attribute/client/meta_editable_attribute_view.coffee'
UserBlockCollectionView = require '../../components/block_collection/client/user_block_collection_view.coffee'
setupBlockCollection = require '../../components/blocks/container/client/index.coffee'

module.exports.init = ->
  current_user = mediator.shared.current_user
  user = new User sd.USER

  if sd.FOLLOWING || sd.FOLLOWERS
    blocks = new FollowBlocks sd.BLOCKS,
      object_id: sd.USER.id
      object_type: 'users'
      suffix: if sd.FOLLOWING then 'ing' else 'ers'
  else
    blocks = new UserBlocks sd.BLOCKS,
      user_slug: sd.USER.slug

    _.extend blocks.options,
      subject: sd.SUBJECT

  setupBlockCollection
    $el: $('.profile-contents')
    collection: blocks

  new PathView
    el: $('section.path--header')
    model: user

  user = new User sd.USER

  new MetaEditableAttributeView
    model: user
    el: $("#metadata--about .metadata__content")
    _attribute: 'description'
    _kind: 'markdown'
    wait: true

  if current_user.isPremium()
    options =
      model: user
      $searchBar: $('.form__field__channel-filter')
      $resultContainer: $('.channel-results-container')
      $channelContainer: $('.grid--user')

    _.extend(options, { subject: sd.SUBJECT }) if sd.SUBJECT

    new Filter options

  user.on 'edit:success', ->
    $.ajax
      method: 'GET'
      url: "#{user.href()}/update"
