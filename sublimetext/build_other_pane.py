import sublime
import sublime_plugin

class BuildOtherPaneCommand(sublime_plugin.WindowCommand):
    def run(self, return_focus=True, **kwargs):
        window = self.window

        hooks = kwargs.get("post_window_hooks", [])
        wingroup = window.active_group()
        print(f"Window group is {wingroup}")
        # Group 0 is left window, Group 1 is Right window
        # if there is only one split and focus is currently in the left panel.
        # or if there is not split at all, take the terminus panel to the right
        # If focus is already in the right, take it below.
        # If there is more than 2 panels keep the output in sitchu
        if window.num_groups() <= 2: 
            if wingroup == 0:
                print("Adding hook to go right")
                hooks = hooks + [["carry_file_to_pane", {"direction": "right"}]]
            else:
                print("Adding hook to go below")
                hooks = hooks + [["carry_file_to_pane", {"direction": "down"}]]


        kwargs["post_window_hooks"] = hooks
        window.run_command("terminus_open", kwargs)



        ## No panel_name => terminus_open creates a VIEW in the active group.
        ## Origami then carries that view to the opposite pane.

        #window.run_command("terminus_open", kwargs)
        ##window.run_command("carry_file_to_pane", {"direction": direction})

        #if return_focus:
        #    # Carry steals focus to the target pane; bounce it back.
        #    # Delay must outlast Terminus's view creation + the carry hook.
        #    sublime.set_timeout(lambda: window.focus_group(current), 100)
