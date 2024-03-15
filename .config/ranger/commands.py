from ranger.api.commands import *

class createFile(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify('Wrong number of arguments', bad=True)
            return
        # First argument. 0 is the command name.
        self.fm.notify(self.arg(1))
        # Current directory to status line.
        self.fm.notify(self.fm.thisdir)
        # Run a shell command.
        self.fm.run(['touch', self.arg(1)])

