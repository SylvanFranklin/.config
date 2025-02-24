function remote --wraps='git remote get-url origin' --description 'alias remote git remote get-url origin'
  git remote get-url origin $argv
        
end
