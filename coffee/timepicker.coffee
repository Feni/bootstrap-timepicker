#
# Timepicker Component
# Original version by Joris de Wit - bootstrap timepicker. 
# 
(($, window, document, undefined_) ->
  "use strict"
  
  # TIMEPICKER PUBLIC CLASS DEFINITION
  Timepicker = (element, options) ->
    @widget = ""
    @$element = $(element)
    @minuteStep = options.minuteStep
    @secondStep = options.secondStep
    @showSeconds = options.showSeconds
    @_init()

  Timepicker:: =
    constructor: Timepicker
    _init: ->
      self = this
      @$widget = $(".template").on("click", $.proxy(@widgetClick, this))
      @$widget.find("input").each ->
        $(this).on
          "click.timepicker": ->
            $(this).select()
          "keydown.timepicker": $.proxy(self.widgetKeydown, self)
      @setDefaultTime()

    decrementHour: ->
      if @hour is 1
        @hour = 12
      else if @hour is 12
        @hour = 11
        return @toggleMeridian()
      else
        @hour--
      @update()

    decrementMinute: (step) ->
      newVal = undefined
      if step
        newVal = @minute - step
      else
        newVal = @minute - @minuteStep
      if newVal < 0
        @decrementHour()
        @minute = newVal + 60
      else
        @minute = newVal
      @update()

    decrementSecond: ->
      newVal = @second - @secondStep
      if newVal < 0
        @decrementMinute true
        @second = newVal + 60
      else
        @second = newVal
      @update()

    getCursorPosition: ->
      input = @$element.get(0)
      if "selectionStart" of input # Standard-compliant browsers
        input.selectionStart
      else if document.selection # IE fix
        input.focus()
        sel = document.selection.createRange()
        selLen = document.selection.createRange().text.length
        sel.moveStart "character", -input.value.length
        sel.text.length - selLen

    # Append zeroes to single digit numbers. return [hour, minute, second]
    normalizeTime: ->
      return [(if @hour < 10 then "0" + @hour else @hour), 
        (if @minute < 10 then "0" + @minute else @minute),
        (if @second < 10 then "0" + @second else @second)]

    getTime: ->
      time = @normalizeTime()
      return time[0] + ":" + time[1] + ((if @showSeconds then ":" + time[2] else "")) + " " + @meridian

    incrementHour: ->
      if @hour is 11
        @hour++
        return @toggleMeridian()
      else @hour = 0  if @hour is 12
      @hour++
      @update()

    incrementMinute: (step) ->
      newVal = undefined
      if step
        newVal = @minute + step
      else
        newVal = @minute + @minuteStep - (@minute % @minuteStep)
      if newVal > 59
        @incrementHour()
        @minute = newVal - 60
      else
        @minute = newVal
      @update()

    incrementSecond: ->
      newVal = @second + @secondStep - (@second % @secondStep)
      if newVal > 59
        @incrementMinute true
        @second = newVal - 60
      else
        @second = newVal
      @update()

    setDefaultTime: () ->
      dTime = new Date()
      hours = dTime.getHours()
      minutes = Math.floor(dTime.getMinutes() / @minuteStep) * @minuteStep
      seconds = Math.floor(dTime.getSeconds() / @secondStep) * @secondStep
      meridian = "AM"
      if hours is 0
        hours = 12
      else if hours >= 12
        hours = hours - 12  if hours > 12
        meridian = "PM"
      else
        meridian = "AM"
      @hour = hours
      @minute = minutes
      @second = seconds
      @meridian = meridian
      @update()

    toggleMeridian: ->
      @meridian = (if @meridian is "AM" then "PM" else "AM")
      @update()

    update: ->
      @$element.trigger
        type: "changeTime.timepicker"
        time:
          value: @getTime()
          hours: @hour
          minutes: @minute
          seconds: @second
          meridian: @meridian

      @updateElement()
      @updateWidget()

    updateElement: ->
      @$element.val(@getTime()).change()

    updateWidget: ->
      return  if @$widget is false
      time = @normalizeTime()
      @$widget.find("input.timepicker-hour").val time[0]
      @$widget.find("input.timepicker-minute").val time[1]
      @$widget.find("input.timepicker-second").val time[2]  if @showSeconds
      @$widget.find("input.timepicker-meridian").val @meridian

    updateFromWidgetInputs: ->
      return  if @$widget is false
      @hour = $("input.timepicker-hour", @$widget).val()
      @minute = $("input.timepicker-minute", @$widget).val()
      @second = $("input.timepicker-second", @$widget).val()
      @meridian = $("input.timepicker-meridian", @$widget).val()
      @hour = 0  if isNaN(@hour)
      @minute = 0  if isNaN(@minute)
      if @hour > 12
        @hour = 12
      else @hour = 12  if @hour < 1
      if @meridian is "am" or @meridian is "a"
        @meridian = "AM"
      else @meridian = "PM"  if @meridian is "pm" or @meridian is "p"
      @meridian = "AM"  if @meridian isnt "AM" and @meridian isnt "PM"
      if @minute < 0
        @minute = 0
      else @minute = 59  if @minute >= 60
      if @showSeconds
        if isNaN(@second)
          @second = 0
        else if @second < 0
          @second = 0
        else @second = 59  if @second >= 60
      @update()      

    widgetClick: (e) ->
      e.stopPropagation()
      e.preventDefault()
      action = $(e.target).closest("a").data("action")
      this[action]()  if action

    widgetKeydown: (e) ->
      $input = $(e.target).closest("input")
      name = $input.attr("name")
      switch e.keyCode
        when 9 #tab
          @updateFromWidgetInputs()
        when 38 # up arrow
          e.preventDefault()
          switch name
            when "hour"
              @incrementHour()
            when "minute"
              @incrementMinute()
            when "second"
              @incrementSecond()
            when "meridian"
              @toggleMeridian()
        when 40 # down arrow
          e.preventDefault()
          switch name
            when "hour"
              @decrementHour()
            when "minute"
              @decrementMinute()
            when "second"
              @decrementSecond()
            when "meridian"
              @toggleMeridian()

  
  #TIMEPICKER PLUGIN DEFINITION
  $.fn.timepicker = (option) ->
    args = Array.apply(null, arguments)
    args.shift()
    @each ->
      $this = $(this)
      data = $this.data("timepicker")
      options = typeof option is "object" and option
      $this.data "timepicker", (data = new Timepicker(this, $.extend({}, $.fn.timepicker.defaults, options, $(this).data())))  unless data
      data[option].apply data, args  if typeof option is "string"


  $.fn.timepicker.defaults =
    minuteStep: 15
    secondStep: 15
    showSeconds: false

  $.fn.timepicker.Constructor = Timepicker
) jQuery, window, document