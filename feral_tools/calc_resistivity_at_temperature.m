function ElResistivity = calc_resistivity_at_temperature(ResistivityRef, TemperatureCoeff, TemperatureRef, Temperature)
%CALC_RESISTIVITY_AT_TEMPERATURE compute the resistivity at a given temperature

ElResistivity = ResistivityRef * (1 + TemperatureCoeff * (Temperature - TemperatureRef )); 

end % function