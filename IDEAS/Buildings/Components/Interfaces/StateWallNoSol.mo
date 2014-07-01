within IDEAS.Buildings.Components.Interfaces;
partial model StateWallNoSol
  "Partial model for building envelope components without solar gains"

  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  ZoneBus propsBus_a annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir(Q_flow=0)
    annotation (Placement(transformation(extent={{80,54},{60,74}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif(Q_flow=0)
    annotation (Placement(transformation(extent={{80,72},{60,92}})));
equation
  connect(iSolDif.port, propsBus_a.iSolDif) annotation (Line(
      points={{60,82},{46,82},{46,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(iSolDir.port, propsBus_a.iSolDir) annotation (Line(
      points={{60,64},{56,64},{56,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics));

end StateWallNoSol;
