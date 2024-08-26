function op --wraps='zathura (find . -name "*.pdf" | sk)' --description 'alias op=zathura (find . -name "*.pdf" | sk)'
  zathura (find . -name "*.pdf" | sk) $argv
        
end
