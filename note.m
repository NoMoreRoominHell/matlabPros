clear

%将多项式与三角函数拟合
%在区间 [0,4*pi] 中沿正弦曲线生成 10 个等间距的点。
x = linspace(0,4*pi,10);
y = sin(x);
%使用 polyfit 将一个 7 次多项式与这些点拟合。
p = polyfit(x,y,7);
%在更精细的网格上计算多项式并绘制结果图。
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
figure
plot(x,y,'o')
hold on
plot(x1,y1)
hold off

%将多项式与点集拟合
%创建一个由区间 [0,1] 中的 5 个等间距点组成的向量，并计算这些点处的 y(x)=(1+x)−1。
x = linspace(0,1,5);
y = 1./(1+x);
%将 4 次多项式与 5 个点拟合。通常，对于 n 个点，可以拟合 n-1 次多项式以便完全通过这些点。
p = polyfit(x,y,4);
%在由 0 和 2 之间的点组成的更精细网格上计算原始函数和多项式拟合。
x1 = linspace(0,2);
y1 = 1./(1+x1);
f1 = polyval(p,x1);
%在更大的区间 [0,2] 中绘制函数值和多项式拟合，其中包含用于获取以圆形突出显示的多项式拟合的点。多项式拟合在原始 [0,1] 区间中的效果较好，但在该区间外部很快与拟合函数出现差异。
figure
plot(x,y,'o')
hold on
plot(x1,y1)
plot(x1,f1,'r--')
legend('y','y1','f1')

%对误差函数进行多项式拟合
%首先生成 x 点的向量，在区间 [0,2.5] 内等间距分布；然后计算这些点处的 erf(x)。
x = (0:0.1:2.5)';
y = erf(x);
%确定 6 次逼近多项式的系数。
p = polyfit(x,y,6);
%为了查看拟合情况如何，在各数据点处计算多项式，并生成说明数据、拟合和误差的一个表。
f = polyval(p,x);
T = table(x,y,f,y-f,'VariableNames',{'X','Y','Fit','FitError'})
%在该区间中，插值与实际值非常符合。创建一个绘图，以显示在该区间以外，外插值与实际数据值如何快速偏离。
x1 = (0:0.1:5)';
y1 = erf(x1);
f1 = polyval(p,x1);
figure
plot(x,y,'o')
hold on
plot(x1,y1,'-')
plot(x1,f1,'r--')
axis([0  5  0  2])
hold off

%使用中心化和缩放改善数值属性
%创建一个由 1750 - 2000 年的人口数据组成的表，并绘制数据点。
year = (1750:25:2000)';
pop = 1e6*[791 856 978 1050 1262 1544 1650 2532 6122 8170 11560]';
T = table(year, pop)

plot(year,pop,'o')

%使用带三个输入的 polyfit 拟合一个使用中心化和缩放的 5 次多项式，这将改善问题的数值属性。polyfit 将 year 中的数据以 0 为进行中心化，并缩放为具有标准差 1，这可避免在拟合计算中出现病态的 Vandermonde 矩阵。
[p,~,mu] = polyfit(T.year, T.pop, 5);
%使用带四个输入的 polyval，根据缩放后的年份 (year-mu(1))/mu(2) 计算 p。绘制结果对原始年份的图。
f = polyval(p,year,[],mu);
hold on
plot(year,f)
hold off

%简单线性回归
%将一个简单线性回归模型与一组离散二维数据点拟合。
%创建几个由样本数据点 (x,y) 组成的向量。对数据进行一次多项式拟合。
x = 1:50; 
y = -0.3*x + 2*randn(1,50); 
p = polyfit(x,y,1); 

%计算在 x 中的点处拟合的多项式 p。用这些数据绘制得到的线性回归模型。
f = polyval(p,x); 
plot(x,y,'o',x,f,'-') 
legend('data','linear fit') 

%具有误差估计值的线性回归
%将一个线性模型拟合到一组数据点并绘制结果，其中包含预测区间为 95% 的估计值。
%创建几个由样本数据点 (x,y) 组成的向量。使用 polyfit 对数据进行一次多项式拟合。指定两个输出以返回线性拟合的系数以及误差估计结构体。
x = 1:100; 
y = -0.3*x + 2*randn(1,100); 
[p,S] = polyfit(x,y,1); 
%计算以 p 为系数的一次多项式在 x 中各点处的拟合值。将误差估计结构体指定为第三个输入，以便 polyval 计算标准误差的估计值。标准误差估计值在 delta 中返回。
[y_fit,delta] = polyval(p,x,S);
%绘制原始数据、线性拟合和 95% 预测区间 y±2Δ。
plot(x,y,'bo')
hold on
plot(x,y_fit,'r-')
plot(x,y_fit+2*delta,'m--',x,y_fit-2*delta,'m--')
title('Linear Fit of Data with 95% Prediction Interval')
legend('Data','Linear Fit','95% Prediction Interval')
