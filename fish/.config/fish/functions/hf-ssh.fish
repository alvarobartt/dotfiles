function hf-ssh --description "SSH into a (my) Hugging Face remote machine/s"
    kitten ssh -i "$HOME/HuggingFace/alvaro-dev-us.pem" $argv
end
