FROM thomahol/d_ssh

# Students asked for tmux
RUN apt-get update && apt-get install -y tmux screen

# Sometimes students misunderstand where to run commands to setup ssh-keys
# Add a warning if students try to run ssh-keygen
RUN echo alias ssh-keygen=\"echo You should not be running ssh-keygen on the proxy host. You should only run ssh-keygen on your remote machine, e.g. the lab machine.\" >> ~/.bashrc

ADD goto_completion /root/.goto_completion
