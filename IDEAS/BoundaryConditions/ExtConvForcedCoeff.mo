within IDEAS.BoundaryConditions;
model ExtConvForcedCoeff
  "Calculates convection coefficient for forced flow at an exterior surface as a function of wind speed and direction"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Angle inc "Surface inclination";
  parameter Modelica.SIunits.Angle azi "Surface azimith";

  Modelica.Blocks.Interfaces.RealOutput hForcedConExt "Forced flow convective heat transfer coefficient at exterior surface" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));
  Modelica.Blocks.Interfaces.RealInput Va "Wind speed" annotation (Placement(transformation(extent={{-126,-30},{-100,-4}})));
  Modelica.Blocks.Interfaces.RealInput Vdir "Wind direction" annotation (Placement(transformation(extent={{-126,-58},{-100,-32}})));

protected
  final parameter Boolean isCeiling=abs(sin(inc)) < 10E-5 and cos(inc) > 0
    "true if ceiling"
    annotation(Evaluate=true);
  final parameter Boolean isFloor=abs(sin(inc)) < 10E-5 and cos(inc) < 0
    "true if floor"
    annotation(Evaluate=true);

  Real a "MoWiTT coeff used for current wind direction";
  Real b "MoWiTT coeff used for current wind direction";
  constant Real a_windward=3.26 "MoWiTT coeff for windward conditions";
  constant Real b_windward=0.89 "MoWiTT coeff for windward conditions";
  constant Real a_leeward=3.55 "MoWiTT coeff for leeward conditions";
  constant Real b_leeward=0.617 "MoWiTT coeff for leeward conditions";

  constant Modelica.SIunits.Angle WindwardVsLeeward=Modelica.SIunits.Conversions.from_deg(100)
    "Angle at which windward vs leeward transition occurs in MoWiTT model";
  constant Real cosWindwardVsLeeward=Modelica.Math.cos(WindwardVsLeeward)
    "Cosine of transition angle";

equation

  if isCeiling then
    a = a_windward;
    b = b_windward;
  elseif isFloor then
    a = a_leeward;
    b = b_leeward;
  else // Treat as a vertical surface
    a = IDEAS.Utilities.Math.Functions.spliceFunction(
      pos=a_leeward,
      neg=a_windward,
      x=cosWindwardVsLeeward - Modelica.Math.cos(azi + Modelica.Constants.pi -
        Vdir),
      deltax=0.05);
    b = IDEAS.Utilities.Math.Functions.spliceFunction(
      pos=b_leeward,
      neg=b_windward,
      x=cosWindwardVsLeeward - Modelica.Math.cos(azi + Modelica.Constants.pi -
        Vdir),
      deltax=0.05);
  end if;

  hForcedConExt = a * Va^b;

  annotation (Documentation(revisions="<html>
<ul>
<li>
November 28, 2019, by Ian Beausoleil-Morrison:<br/>
First implementation.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/1089\">
#1089</a>
</li>
</ul>
</html>", info="<html>
<p>This model calculates the convection coefficient at an exterior surface for pure forced flow conditions. The forced flow coefficient resulting from this model will be later combined in ExteriorConvection.mo with a coefficient for purely natural convection conditions to produce a coefficient for combined natural and forced flow.</p>
<p>It applies the &quot;MoWitt&quot; correlation for forced flow, which is empircally derived from a window test facility. The correlation&apos;s coefficients are taken from the EnergyPlus Engineering manual (Table 3.9, Page 95). Different coefficients are used in the correlation depending on whether the surface is &quot;windward&quot; or &quot;leeward&quot;. In this implementation a vertical surface is considered leeward if the wind angle is more than 100 degrees from normal incidence. Ceilings are always treated as windward, while floors are always treated as leeward.</p>
<p>Horizontal&nbsp;surfaces are treated as either a ceiling or a floor. Any non-horizontal surface is treated as vertical.</p>
<p>The wind speed from the weather file is used in the MoWiTT correlation: no adjustments are made for building height or local wind sheltering.</p>
</html>"));
end ExtConvForcedCoeff;
