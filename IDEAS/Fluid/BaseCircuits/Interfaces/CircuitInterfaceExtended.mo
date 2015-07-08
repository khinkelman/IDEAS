within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model CircuitInterfaceExtended "Partial circuit for base circuits"

  extends CircuitInterface;

  //Parameters
  parameter Integer tauTSensor = 120 "Time constant of the temperature sensors";

  //----Settings
  parameter Boolean includePipes=false
    "Set to true to include pipes in the basecircuit"
    annotation(Dialog(group = "Settings"));
  parameter Boolean measureSupplyT=false
    "Set to true to measure the supply temperature"
    annotation(Dialog(group = "Settings"));

  parameter Boolean measureReturnT=false
    "Set to true to measure the return temperature"
    annotation(Dialog(group = "Settings"));

  //----if includePipes
  parameter SI.Mass m=1 if includePipes
    "Mass of medium in the supply and return pipes"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));
  parameter SI.ThermalConductance UA=10
    "Thermal conductance of the insulation of the pipes"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));
  parameter Modelica.SIunits.Pressure dp=0 "Pressure drop over a single pipe"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));

  // Components ----------------------------------------------------------------

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if includePipes
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput Tsup if measureSupplyT
    "Supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,104})));

  Modelica.Blocks.Interfaces.RealOutput Tret if measureReturnT
    "Return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,-104})));

protected
  FixedResistances.InsulatedPipe pipeSupply(
    UA=UA,
    m=m/2,
    dp_nominal=dp,
    energyDynamics=energyDynamics,
    dynamicBalance=dynamicBalance,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) if
                                          includePipes
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,60})), choicesAllMatching=true);
  FixedResistances.InsulatedPipe pipeReturn(
    UA=UA,
    dp_nominal=dp,
    m=m/2,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    dynamicBalance=dynamicBalance,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium) if includePipes
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-60})),                                            choicesAllMatching=true);
  Sensors.TemperatureTwoPort senTemSup(
    m_flow_nominal=m_flow_nominal,
    tau=tauTSensor,
    redeclare package Medium = Medium) if measureSupplyT
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Sensors.TemperatureTwoPort senTemRet(
    m_flow_nominal=m_flow_nominal,
    tau=tauTSensor,
    redeclare package Medium = Medium) if measureReturnT
    annotation (Placement(transformation(extent={{-60,-50},{-80,-70}})));

equation
  connect(port_a1, pipeSupply.port_a) annotation (Line(
      points={{-100,60},{-90,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort, heatPort) annotation (Line(
      points={{-80,56},{-80,-40},{-24,-40},{-24,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn.heatPort, heatPort) annotation (Line(
      points={{-40,-56},{-40,-40},{-24,-40},{-24,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, senTemSup.port_b) annotation (Line(
      points={{100,60},{80,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Tsup, Tsup) annotation (Line(
      points={{70,108},{70,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemSup.T, Tsup) annotation (Line(
      points={{70,71},{70,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_b2, senTemRet.port_b) annotation (Line(
      points={{-100,-60},{-80,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemRet.port_a, pipeReturn.port_b) annotation (Line(
      points={{-60,-60},{-50,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemRet.T, Tret) annotation (Line(
      points={{-70,-71},{-70,-108}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Placement(transformation(extent={{60,10},{80,30}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-50},{-80,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=includePipes),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={90,60},
          rotation=180,
          visible=includePipes),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={90,-60},
          rotation=180,
          visible=includePipes),
        Rectangle(
          extent={{-100,70},{-80,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=includePipes),
        Polygon(
          points={{-80,70},{-80,50},{-72,60},{-80,70}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=includePipes),
        Polygon(
          points={{-80,-50},{-80,-70},{-72,-60},{-80,-50}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=includePipes),
        Polygon(
          points={{-4,10},{-4,-10},{4,0},{-4,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={76,60},
          rotation=180,
          visible=includePipes),
        Polygon(
          points={{80,-50},{80,-70},{72,-60},{80,-50}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=includePipes)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end CircuitInterfaceExtended;
