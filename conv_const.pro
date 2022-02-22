function conv_const, pressure, temp_obj, temp_env, length, geom=geom,quiet=quiet

;;Calculates the convective heat transfer coefficient for an object
;------------------------------------------------------------------
;;Arguments:
;;pressure - air pressure (Pa)
;;temp_obj - temperature of object (K)
;;temp_env - temperature of environment (K)
;;length - characteristic length (m); length of plate or diameter of cylinder
;;geom - geometry of object. Options:
;;  'vert_plate' - Vertical Plate (default)
;;  'cylinder' - Vertical Cylinder
;;  'horiz_plate' - Horizontal Plate
;;  'horiz_cylinder' - Horizontal Cylinder
;------------------------------------------------------------------
;;Assumptions:
;;Ideal Gas Law as predictor of density, ... 
;;Approximates atmosphere as Nitrogen

;;Equations for Viscosity, Thermal Conductivity, Prandtl Number include a dimensionless constant ~1
;;Set these constants so that values best matched region of interest (~10000 Pa, -30 C)
;-------------------------------------------------------------------
;;Output:
;;h - convective heat transfer coefficient (W/m^2/K)
;-------------------------------------------------------------------
;;Error Analysis:
;;Used Data from Engineering Toolbox, Omnicalculator, looking at temperature and pressure dependance seperately due to availability of data
;;rho - +/- 0.3% @ -50->25 C, 1e5 -> 1e6 Pa
;;l -   +/- 0.02% @ 250->300 K, 1e4 -> 1e6 Pa
;;mu -  +/- 2% @ 250 -> 280 K, 1 bar

;;cp -  +/- 1% @ STP (No T dependence assumed)
;;cv -  +/- 1% @

;;k -   +/- 4% @ 220->270 K (Exact ~245), 1 bar
;;pr -  +/- 1.3% @ 200->273K (Exact 240 K), 1 bar

;;The remaining values are derived from worst-case error propagation, as there were not standard values I found.
;;gr -  +/- x% 
;;ra -  +/- x% 
;;h -   +/- x% 
;-------------------------------------------------------------------

p = double(pressure)
to = double(temp_obj)
tenv = double(temp_env)
l0 = double(length)

n = max([n_elements(p),n_elements(to),n_elements(tenv),n_elements(l0)])
h = dblarr(n)

if keyword_set(geom) then geom = strlowcase(geom) else geom = 'vert_plate'

;;Constants
;-------------------------------------------------------------------------------------------
r = 8.314463d                       ;Ideal Gas constant (J/mol/K)
na = 6.02214086d23                  ;Avogadros Number (1/mol)
mw0 = 28.02                         ;Molecular Mass of Nitrogen (Da/mol)
mw = mw0 * 1.66054d-27              ;Molecular Mass of Nitrogen (kg/mol)
kb = 1.3806485d-23                  ;Boltzmann Constant (J/K)
dk = 3.64d-10                       ;Kinetic diameter of N2 molecule (m)
g = 9.81                            ;Acceleration from gravity (m/s^2)

cv = 0.97*(1000/mw0)*(2.5)*r        ;Heat Capacity (J/kg K)
cp =  cv + (1000/mw0)*r

tf = (to + tenv) / 2                ;Film Temperature
dt = to - tenv                      ;Temperature Difference

;;Get Gas Properties
;------------------------------------------------------------------------------------------
rho_n = 1.0331 * p/(r*tf) * na                  ;Number Density (1/m^3)
rho = rho_n * mw                                  ;Density (kg/m^3)

l = kb*tf/(sqrt(2)*!pi*dk^2.*p)                 ;Mean Free Path (m)

mu = 0.9139*rho*l*sqrt(2*kb*tf/(!pi*mw))        ;Viscosity (N*s/m^2)

k = 1.75 * rho*l*cv*sqrt(2*kb*tf/(!pi*mw))      ;Thermal Conductivity (W/m K)

;;Verify Gas regime
if 10.*MAX(l) GE MIN(l0) then print, 'Warning: mean free path is on the order of characteristic length!'

;;Derive dimensionless quantities
;-------------------------------------------------------------------------------------------
pr = 0.972 * cp * mu / k                                  ;Prandtl Number

case geom of
    'vert_plate': gr = (g/tf)*l0^3. * (rho/mu)^2.       ;Grashof Number
    'cylinder': gr = (g/tf)*l0^3. * (rho/mu)^2. 
    'horiz_plate': gr = 1       
endcase

ra = pr * gr                                              ;Rayleigh Number

;;Check flow regime
if MAX(ra) GT 1e12 then print, 'Rayleigh number exceeds 10^12, laminar regime not valid for all values'
if MIN(ra) LT 1e-1 then print, 'Rayleigh number less than 1e-1, outside area of approximation'

;;Calculate convective heat transfer coefficient
;------------------------------------------------------------------------------------------
case geom of
    'vert_plate': begin
        sel1 = where((ra LE 1e9) AND (ra GE 1e-1),count, complement=sel2, ncomplement=ncount)
        if count GE 1 then h[sel1] = (k/l0)*(0.825 + 0.387*ra[sel1]^(1./6)/(1 + (0.492/pr)^(9./16))^(8./27))^2.
        if ncount GE 1 then h[sel2] = (k/l0)*(0.68 + 0.67*ra[sel2]^(1./4)/(1 + (0.492/pr)^(9./16))^(4./9))
    end
    'cylinder': h = 1
    'horiz_plate': h = 1
endcase

;;Print Results
;---------------------------------------------------------------------------------------------
if not keyword_set(quiet) then begin
    print,'Pressure: '+string(p)
    print,'Temperature of Object: '+string(to)
    print,'Temperature of Environment: '+string(tenv)
    print, 'Mean Free Path: '+string(l)
    print, 'Convection Coefficient: '+string(h)
endif

return, h
end