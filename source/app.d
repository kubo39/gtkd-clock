import gio.Application : GioApplication = Application;
import glib.Timeout;
import gtk.Application;
import gtk.ApplicationWindow;
import gtk.Label;

import std.datetime;

string currentTime()
{
    return Clock.currTime.toSimpleString;
}

class MainWindow : ApplicationWindow
{
    this(Application application)
    {
        super(application);
        setTitle("GtkD Clock");

        setBorderWidth(10);
        setPosition(WindowPosition.CENTER);
        setDefaultSize(260, 40);
        auto time = currentTime;
        auto label = new Label("");
        label.setText(time);
        add(label);

        addOnDelete((win, _) {
                win.destroy();
                return false;
            });
        showAll();

        // labelの参照をキャプチャしたいのでdelegateを使う
        new Timeout(() {
                auto time = currentTime;
                label.setText(time);
                return true;
            }, 1 /* second. */);
    }
}

int main(string[] args)
{
    auto application = new Application("com.github.kubo39.gtkd-clock", GApplicationFlags.FLAGS_NONE);
    application.addOnActivate((GioApplication _) {
            new MainWindow(application);
        });
    return application.run(args);
}
