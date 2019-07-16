function welcome_to_feral()

disp('Congratualations!')
disp('The FeRaL libraries have been loaded successfully')

try 
  openfemm;
  closefemm;
  disp('Good! The FEMM library is loaded too!')
  disp('Ok, it''s time to simulate ...')
catch
  disp('It seems that you heve not loaded the FEMM library yet...')
  disp('Come on, what are you wainting for?')
  disp('Follow the instructions in the manual and start using FeRaL!')
end

end % function