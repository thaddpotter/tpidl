pro check_composite

raw = '~/idl/end2end/data/stop/Composite_Test_Raw.txt'
proc = '~/idl/end2end/data/stop/Composite_Test_Proc.txt'

raw_struct = read_comsol_disp(raw, delim=';')
proc_struct = read_comsol_disp(proc, delim=';')

raw_data = transpose([[raw_struct.X],[raw_struct.Y],[raw_struct.Z]])
proc_data = transpose([[proc_struct.X],[proc_struct.Y],[proc_struct.Z]])

roc = 3.048d
k = -1
init = [90d,0,0d,0d,0d]

rawsol = fit_conic(raw_data[*,0:5000:10], roc, k,guess=init)
procsol = fit_conic(proc_data[*,0:3000:6], roc, k,guess=rawsol[0:4])

print, 'RMS Distance for Raw: '+n2s(1000*SQRT(rawsol[5]/n_elements(501d)))+' mm'
print, 'RMS Distance for Proc: '+n2s(1000*SQRT(procsol[5]/n_elements(501d)))+' mm'

end