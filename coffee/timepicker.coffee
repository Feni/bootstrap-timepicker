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

    decHr: ->
      if @hour is 1
        @hour = 12
      else if @hour is 12
        @hour = 11
        return @toggleMeridian()
      else
        @hour--
      @update()

    decMin: (step) ->
      newVal = undefined
      if step
        newVal = @minute - step
      else
        newVal = @minute - @minuteStep
      if newVal < 0
        @decHr()
        @minute = newVal + 60
      else
        @minute = newVal
      @update()

    decSec: ->
      newVal = @second - @secondStep
      if newVal < 0
        @decMin true
        @second = newVal + 60
      else
        @second = newVal
      @update()

    # Append zeroes to single digit numbers. return [hour, minute, second]
    normalizeTime: ->
      return [(if @hour < 10 then "0" + @hour else @hour), 
        (if @minute < 10 then "0" + @minute else @minute),
        (if @second < 10 then "0" + @second else @second)]

    getTime: ->
      time = @normalizeTime()
      return time[0] + ":" + time[1] + ((if @showSeconds then ":" + time[2] else "")) + " " + @meridian

    incHr: ->
      if @hour is 11
        @hour++
        return @toggleMeridian()
      else @hour = 0  if @hour is 12
      @hour++
      @update()

    incMin: (step) ->
      newVal = undefined
      if step
        newVal = @minute + step
      else
        newVal = @minute + @minuteStep - (@minute % @minuteStep)
      if newVal > 59
        @incHr()
        @minute = newVal - 60
      else
        @minute = newVal
      @update()

    incSec: ->
      newVal = @second + @secondStep - (@second % @secondStep)
      if newVal > 59
        @incMin true
        @second = newVal - 60
      else
        @second = newVal
      @update()

    setDefaultTime: () ->
      dTime = new Date()
      @hour = dTime.getHours()
      @minute = Math.floor(dTime.getMinutes() / @minuteStep) * @minuteStep
      @second = Math.floor(dTime.getSeconds() / @secondStep) * @secondStep
      @meridian = "AM"
      if @hour is 0
        @hour = 12
      else if @hour >= 12
        @hour = @hour - 12  if @hour > 12
        @meridian = "PM"
      else
        @meridian = "AM"
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
      @updateWidget()

    updateWidget: ->
      return  if @$widget is false
      time = @normalizeTime()
      @$widget.find("input.tp-hr").val time[0]
      @$widget.find("input.tp-min").val time[1]
      @$widget.find("input.tp-sec").val time[2]  if @showSeconds
      @$widget.find("input.tp-meridian").val @meridian

    updateFromWidgetInputs: ->
      return  if @$widget is false
      @hour = $("input.tp-hr", @$widget).val()
      @minute = $("input.tp-min", @$widget).val()
      @second = $("input.tp-sec", @$widget).val()
      @meridian = $("input.tp-meridian", @$widget).val()
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
              @incHr()
            when "minute"
              @incMin()
            when "second"
              @incSec()
            when "meridian"
              @toggleMeridian()
        when 40 # down arrow
          e.preventDefault()
          switch name
            when "hour"
              @decHr()
            when "minute"
              @decMin()
            when "second"
              @decSec()
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