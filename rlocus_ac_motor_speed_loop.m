s=tf('s'); Ts=1/4000;
wsc=100; J=0.00016;  % 速度环帶寬wsc=100 rad/s
Kp_w=J*wsc; Ki_w=Kp_w*wsc/5; % 設計PI控制器的Kp, Ki值
K1 = 1; K2 = 0.1; K3 = 10; % 不同回路增益
tf_pi=tf([Kp_w Ki_w],[1 0]); % PI控制器
tf_plant=tf(1,[J 0]); % 受控廠
tf_currLoop = tf(1000, [1 1000]); % 電流环設計為帶寬為1000 rad/s的低通濾波器
tf_totalDelay = exp(-s*1.5*Ts); % 總延遲時間為1.5*Ts (PWM標準採樣法)
[num1, den1] = pade(1.5*Ts, 1); % 使用一階Pade近似exp(-s*1.5*Ts)
tf_totalDelay_Pade = tf(num1, den1); % 建立一階延遲Pade近似轉移函數
Go_w_noDelay= tf_pi*tf_plant; % 計算開环傳遞函數
Go_w_withDelay = tf_pi*tf_plant*tf_currLoop*tf_totalDelay_Pade;
h=bodeoptions;
h.PhaseMatching='on';
h.Title.FontSize = 14;
h.XLabel.FontSize = 14;
h.YLabel.FontSize = 14;
h.TickLabel.FontSize = 14;
figure(1)
subplot(1,2,1)
rlocus(Go_w_noDelay); legend('noDelay');
subplot(1,2,2)
rlocus(Go_w_withDelay); legend('withDelay');
figure(2)
bodeplot(28*Go_w_withDelay,'-k',{1,10000},h);
legend('withDelay');
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid on;
