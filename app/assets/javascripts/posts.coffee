# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#posts').imagesLoaded ->
		$('#posts').masonry
			itemSelector: '.box'
			isFitWidth: true

$ ->
	$('#topics').imagesLoaded ->
		$('#topics').masonry
			itemSelector: '.box1'
			isFitWidth: true