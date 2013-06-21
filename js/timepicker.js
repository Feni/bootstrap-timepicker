// Generated by CoffeeScript 1.4.0
(function() {

  (function($, window, document, undefined_) {
    "use strict";

    var Timepicker;
    Timepicker = function(element, options) {
      this.widget = "";
      this.$element = $(element);
      this.minuteStep = options.minuteStep;
      this.secondStep = options.secondStep;
      this.showSeconds = options.showSeconds;
      return this._init();
    };
    Timepicker.prototype = {
      constructor: Timepicker,
      _init: function() {
        var self;
        self = this;
        this.$widget = $(".template").on("click", $.proxy(this.widgetClick, this));
        this.$widget.find("input").each(function() {
          return $(this).on({
            "click.timepicker": function() {
              return $(this).select();
            },
            "keydown.timepicker": $.proxy(self.widgetKeydown, self)
          });
        });
        return this.setDefaultTime();
      },
      decrementHour: function() {
        if (this.hour === 1) {
          this.hour = 12;
        } else if (this.hour === 12) {
          this.hour = 11;
          return this.toggleMeridian();
        } else {
          this.hour--;
        }
        return this.update();
      },
      decrementMinute: function(step) {
        var newVal;
        newVal = void 0;
        if (step) {
          newVal = this.minute - step;
        } else {
          newVal = this.minute - this.minuteStep;
        }
        if (newVal < 0) {
          this.decrementHour();
          this.minute = newVal + 60;
        } else {
          this.minute = newVal;
        }
        return this.update();
      },
      decrementSecond: function() {
        var newVal;
        newVal = this.second - this.secondStep;
        if (newVal < 0) {
          this.decrementMinute(true);
          this.second = newVal + 60;
        } else {
          this.second = newVal;
        }
        return this.update();
      },
      getCursorPosition: function() {
        var input, sel, selLen;
        input = this.$element.get(0);
        if ("selectionStart" in input) {
          return input.selectionStart;
        } else if (document.selection) {
          input.focus();
          sel = document.selection.createRange();
          selLen = document.selection.createRange().text.length;
          sel.moveStart("character", -input.value.length);
          return sel.text.length - selLen;
        }
      },
      normalizeTime: function() {
        return [(this.hour < 10 ? "0" + this.hour : this.hour), (this.minute < 10 ? "0" + this.minute : this.minute), (this.second < 10 ? "0" + this.second : this.second)];
      },
      getTime: function() {
        var time;
        time = this.normalizeTime();
        return time[0] + ":" + time[1] + (this.showSeconds ? ":" + time[2] : "") + " " + this.meridian;
      },
      incrementHour: function() {
        if (this.hour === 11) {
          this.hour++;
          return this.toggleMeridian();
        } else {
          if (this.hour === 12) {
            this.hour = 0;
          }
        }
        this.hour++;
        return this.update();
      },
      incrementMinute: function(step) {
        var newVal;
        newVal = void 0;
        if (step) {
          newVal = this.minute + step;
        } else {
          newVal = this.minute + this.minuteStep - (this.minute % this.minuteStep);
        }
        if (newVal > 59) {
          this.incrementHour();
          this.minute = newVal - 60;
        } else {
          this.minute = newVal;
        }
        return this.update();
      },
      incrementSecond: function() {
        var newVal;
        newVal = this.second + this.secondStep - (this.second % this.secondStep);
        if (newVal > 59) {
          this.incrementMinute(true);
          this.second = newVal - 60;
        } else {
          this.second = newVal;
        }
        return this.update();
      },
      setDefaultTime: function() {
        var dTime, hours, meridian, minutes, seconds;
        dTime = new Date();
        hours = dTime.getHours();
        minutes = Math.floor(dTime.getMinutes() / this.minuteStep) * this.minuteStep;
        seconds = Math.floor(dTime.getSeconds() / this.secondStep) * this.secondStep;
        meridian = "AM";
        if (hours === 0) {
          hours = 12;
        } else if (hours >= 12) {
          if (hours > 12) {
            hours = hours - 12;
          }
          meridian = "PM";
        } else {
          meridian = "AM";
        }
        this.hour = hours;
        this.minute = minutes;
        this.second = seconds;
        this.meridian = meridian;
        return this.update();
      },
      toggleMeridian: function() {
        this.meridian = (this.meridian === "AM" ? "PM" : "AM");
        return this.update();
      },
      update: function() {
        this.$element.trigger({
          type: "changeTime.timepicker",
          time: {
            value: this.getTime(),
            hours: this.hour,
            minutes: this.minute,
            seconds: this.second,
            meridian: this.meridian
          }
        });
        this.updateElement();
        return this.updateWidget();
      },
      updateElement: function() {
        return this.$element.val(this.getTime()).change();
      },
      updateWidget: function() {
        var time;
        if (this.$widget === false) {
          return;
        }
        time = this.normalizeTime();
        this.$widget.find("input.timepicker-hour").val(time[0]);
        this.$widget.find("input.timepicker-minute").val(time[1]);
        if (this.showSeconds) {
          this.$widget.find("input.timepicker-second").val(time[2]);
        }
        return this.$widget.find("input.timepicker-meridian").val(this.meridian);
      },
      updateFromWidgetInputs: function() {
        if (this.$widget === false) {
          return;
        }
        this.hour = $("input.timepicker-hour", this.$widget).val();
        this.minute = $("input.timepicker-minute", this.$widget).val();
        this.second = $("input.timepicker-second", this.$widget).val();
        this.meridian = $("input.timepicker-meridian", this.$widget).val();
        if (isNaN(this.hour)) {
          this.hour = 0;
        }
        if (isNaN(this.minute)) {
          this.minute = 0;
        }
        if (this.hour > 12) {
          this.hour = 12;
        } else {
          if (this.hour < 1) {
            this.hour = 12;
          }
        }
        if (this.meridian === "am" || this.meridian === "a") {
          this.meridian = "AM";
        } else {
          if (this.meridian === "pm" || this.meridian === "p") {
            this.meridian = "PM";
          }
        }
        if (this.meridian !== "AM" && this.meridian !== "PM") {
          this.meridian = "AM";
        }
        if (this.minute < 0) {
          this.minute = 0;
        } else {
          if (this.minute >= 60) {
            this.minute = 59;
          }
        }
        if (this.showSeconds) {
          if (isNaN(this.second)) {
            this.second = 0;
          } else if (this.second < 0) {
            this.second = 0;
          } else {
            if (this.second >= 60) {
              this.second = 59;
            }
          }
        }
        return this.update();
      },
      widgetClick: function(e) {
        var action;
        e.stopPropagation();
        e.preventDefault();
        action = $(e.target).closest("a").data("action");
        if (action) {
          return this[action]();
        }
      },
      widgetKeydown: function(e) {
        var $input, name;
        $input = $(e.target).closest("input");
        name = $input.attr("name");
        switch (e.keyCode) {
          case 9:
            return this.updateFromWidgetInputs();
          case 38:
            e.preventDefault();
            switch (name) {
              case "hour":
                return this.incrementHour();
              case "minute":
                return this.incrementMinute();
              case "second":
                return this.incrementSecond();
              case "meridian":
                return this.toggleMeridian();
            }
            break;
          case 40:
            e.preventDefault();
            switch (name) {
              case "hour":
                return this.decrementHour();
              case "minute":
                return this.decrementMinute();
              case "second":
                return this.decrementSecond();
              case "meridian":
                return this.toggleMeridian();
            }
        }
      }
    };
    $.fn.timepicker = function(option) {
      var args;
      args = Array.apply(null, arguments);
      args.shift();
      return this.each(function() {
        var $this, data, options;
        $this = $(this);
        data = $this.data("timepicker");
        options = typeof option === "object" && option;
        if (!data) {
          $this.data("timepicker", (data = new Timepicker(this, $.extend({}, $.fn.timepicker.defaults, options, $(this).data()))));
        }
        if (typeof option === "string") {
          return data[option].apply(data, args);
        }
      });
    };
    $.fn.timepicker.defaults = {
      minuteStep: 15,
      secondStep: 15,
      showSeconds: false
    };
    return $.fn.timepicker.Constructor = Timepicker;
  })(jQuery, window, document);

}).call(this);
