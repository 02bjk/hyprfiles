
#!/usr/bin/env python3
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GdkPixbuf
import os
import subprocess
import sys
import traceback

# Edit this to point to your wallpapers directory
WALL_DIR = "/home/kazzu/Pictures/wallpapers"

# Thumbnail size
THUMB_W = 200
THUMB_H = 200

class WallpaperPicker(Gtk.Window):
    def __init__(self):
        super().__init__(title="Pick Wallpaper")
        self.set_default_size(600, 400)
        self.set_border_width(8)

        self.flowbox = Gtk.FlowBox()
        self.flowbox.set_valign(Gtk.Align.START)
        self.flowbox.set_max_children_per_line(4)
        self.flowbox.set_selection_mode(Gtk.SelectionMode.NONE)

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(self.flowbox)
        self.add(scroll)

        # populate
        if not os.path.isdir(WALL_DIR):
            print(f"WALL_DIR does not exist: {WALL_DIR}", file=sys.stderr)
        else:
            for fname in sorted(os.listdir(WALL_DIR)):
                fpath = os.path.join(WALL_DIR, fname)
                if not os.path.isfile(fpath):
                    continue
                # try to load thumbnail; if it fails, skip
                try:
                    pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(fpath, THUMB_W, THUMB_H, True)
                    image = Gtk.Image.new_from_pixbuf(pixbuf)
                except Exception:
                    # if loading fails, fall back to a text label
                    image = Gtk.Image.new_from_icon_name("image-x-generic", Gtk.IconSize.DIALOG)

                btn = Gtk.Button()
                btn.set_image(image)
                btn.set_always_show_image(True)
                # store path on the button with a lambda closure
                btn.connect("clicked", self.on_select, fpath)
                self.flowbox.add(btn)

        self.show_all()

    def on_select(self, widget, filepath):
        """
        When a thumbnail is clicked:
        - launch the three commands asynchronously (so UI doesn't block)
        - close the window and quit GTK immediately (no confirmations)
        """
        cmds = [
            ["dms", "ipc", "call", "wallpaper", "set", filepath],
            ["wal", "-n", "-i", filepath],
            ["matugen", "image", filepath],
        ]

        for cmd in cmds:
            try:
                # start processes without waiting (so we can close the UI right away)
                subprocess.Popen(cmd)
            except FileNotFoundError:
                # binary not found in PATH
                print(f"Command not found: {cmd[0]} (tried: {' '.join(cmd)})", file=sys.stderr)
            except Exception:
                print(f"Failed to start command: {' '.join(cmd)}", file=sys.stderr)
                traceback.print_exc()

        # close the window and exit GTK main loop immediately
        try:
            # If this window has a parent or other windows, calling destroy() then main_quit is safe.
            self.destroy()
        except Exception:
            pass
        Gtk.main_quit()


if __name__ == "__main__":
    win = WallpaperPicker()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()
