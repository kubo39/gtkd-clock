import gio.Application : GioApplication = Application;
import glib.Timeout;
import gtk.Application;
import gtk.ApplicationWindow;
import gtk.Label;

import std.datetime;

string currentTime()
{
    auto now = Clock.currTime;
    return now.toISOExtString;
}

void buildUI(Application application)
{
    auto window = new ApplicationWindow(application);
    window.setTitle("GtkD Clock");
    window.setBorderWidth(10);
    window.setPosition(WindowPosition.CENTER);
    window.setDefaultSize(260, 40);

    window.addOnDelete((win, _) {
            win.destroy();
            return false;
        });

    auto time = currentTime;
    auto label = new Label("");
    label.setText(time);
    window.add(label);
    window.showAll();

    // labelの参照をキャプチャしたいのでdelegateを使う
    new Timeout(() {
            auto time = currentTime;
            label.setText(time);
            return true;
        }, 1);
}

void main(string[] args)
{
    auto application = new Application("com.github.gtkd-clock", GApplicationFlags.FLAGS_NONE);

    application.addOnStartup((GioApplication app) {
            buildUI(application);
        });

    application.addOnActivate((GioApplication _) {});

    application.run(args);
}
