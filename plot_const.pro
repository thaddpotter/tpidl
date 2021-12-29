pro plot_const

p = 400
t_obj = 253
t_env = 240

h = 0
l_arr = dindgen(1000,start=0.01,increment=0.0001)
h_arr = dblarr(1000,1)

for i = 0,999 do begin
    conv_const, p, t_obj, t_env, l_arr[i], h=h
    h_arr[i] = h
end

plt1 = plot(100*l_arr,h_arr, xtitle='Scale length (cm)',ytitle='Convective heat transfer coefficient')

q_arr = (t_obj-t_env) * h_arr * (l_arr^2)

plt2 = plot(100*l_arr, q_arr, xtitle='Scale length (cm)',ytitle='Transmitted heat (W)')

end