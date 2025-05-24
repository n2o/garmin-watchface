import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class helloworldView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Get screen dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // Set hand properties
        dc.setPenWidth(3);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);

        // Calculate hour hand position
        // 360 degrees / 12 hours = 30 degrees per hour
        // 30 degrees / 60 minutes = 0.5 degrees per minute
        var hourAngle = Math.toRadians((hours % 12) * 30 + clockTime.min * 0.5 - 90); // -90 to make 12 o'clock top
        var hourHandLength = width / 4;
        var hourX = centerX + hourHandLength * Math.cos(hourAngle);
        var hourY = centerY + hourHandLength * Math.sin(hourAngle);
        dc.drawLine(centerX, centerY, hourX, hourY);

        // Calculate minute hand position
        // 360 degrees / 60 minutes = 6 degrees per minute
        var minuteAngle = Math.toRadians(clockTime.min * 6 - 90); // -90 to make 12 o'clock top
        var minuteHandLength = width / 2 - 10; // Slightly shorter than half width
        var minuteX = centerX + minuteHandLength * Math.cos(minuteAngle);
        var minuteY = centerY + minuteHandLength * Math.sin(minuteAngle);
        dc.drawLine(centerX, centerY, minuteX, minuteY);

        // Calculate second hand position
        // 360 degrees / 60 seconds = 6 degrees per second
        var secondAngle = Math.toRadians(clockTime.sec * 6 - 90); // -90 to make 12 o'clock top
        var secondHandLength = width / 2 - 5; // Slightly longer than minute hand
        var secondX = centerX + secondHandLength * Math.cos(secondAngle);
        var secondY = centerY + secondHandLength * Math.sin(secondAngle);
        // Optionally, set a different color for the second hand
        // dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(centerX, centerY, secondX, secondY);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
