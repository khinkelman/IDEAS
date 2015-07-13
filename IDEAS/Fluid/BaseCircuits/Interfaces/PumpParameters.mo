within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model PumpParameters
  "Partial circuit for base circuits with pump parameters"

  parameter Integer tauPump = 1
    "Time constant of the pump if dynamicBalance is true"
    annotation(Dialog(
                   group = "Pump parameters"));

  parameter Boolean addPowerToMedium = false "Add heat to the medium"
                             annotation(Dialog(
                   group = "Pump parameters"));
  parameter Boolean use_powerCharacteristic = false
    "Use powerCharacteristic (vs. efficiencyCharacteristic)" annotation(Dialog(
                   group = "Pump parameters"));
  parameter Boolean motorCooledByFluid = true
    "If true, then motor heat is added to fluid stream" annotation(Dialog(
                   group = "Pump parameters"));

end PumpParameters;
