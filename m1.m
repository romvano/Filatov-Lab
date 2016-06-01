% амплитудная модуляция
Fs = 4000; % частота дискретизации
f = 100; % частота сигнала
Fm = 1000; % частота модулирующего сигнала
t = ( 0 : 1 / Fs : 4 )'; % длительность сигнала 4 с
A = 10; % амплитуда сигнала, В
Am = 15; % амплитуда модулирующего сигнала, В

s = A .* sin( 2 .* pi .* f .* t ); % сигнал

y = ammod( s, Fm, Fs, 0, Am ); % модулированный сигнал, 
plot( t, y ); % строим график
xlabel( 't, Время, с' );
ylabel( 'А, амплитуда сигнала, В' );
title( 'Амплитудная модуляция' );

% картинка 1

Y = 2 * abs( fft( y ) / length( y ) ); % строим спектр
freqs = Fs * ( 0 : length( y ) / 2 ) / length( y ); % вектор частот
plot( freqs, Y( 1 : length( y ) / 2 + 1 ) ); % график спектра
xlabel( 'f, частота, Гц' );
ylabel( 'A, амплитуда, В' );
title( 'Спектр амплитудномодулированного сигнала' );

% картинка 2

% АМ с подавленной несущей
y = ammod( s, Fm, Fs ); % модулированный сигнал


% картинка 3

Y = 2 * abs( fft( y ) / length( y ) ); % строим спектр
freqs = Fs * ( 0 : length( y ) / 2 ) / length( y ); % вектор частот
plot( freqs, Y( 1 : length( y ) / 2 + 1 ) ); % график спектра
xlabel( 'f, частота, Гц' );
ylabel( 'A, амплитуда, В' );
title( 'Спектр амплитудномодулированного сигнала с подавленной несущей' );

% картинка 4

% АМ с подавленной боковой
y = ssbmod( s, Fm, Fs ); % модулированный сигнал
plot( t, y ); % строим график
xlabel( 't, Время, с' );
ylabel( 'А, амплитуда сигнала, В' );
title( 'Амплитудная модуляция с подавленной боковой' );

% картинка 5

Y = 2 * abs( fft( y ) / length( y ) ); % строим спектр
freqs = Fs * ( 0 : length( y ) / 2 ) / length( y ); % вектор частот
plot( freqs, Y( 1 : length( y ) / 2 + 1 ) ); % график спектра
xlabel( 'f, частота, Гц' );
ylabel( 'A, амплитуда, В' );
title( 'Спектр амплитудномодулированного сигнала с подавленной боковой' );

% подавили верхнюю боковую
% картинка 6




% амплитудно-импульсная модуляция, побитовая передача
M = 8; % глубина модуляции
k = log2( M ); % количество битов на символ
binInputData = randi( [ 0 1 ], 1024, k ); % формируем входные данные
decInputData = bi2de( binInputData ); % переводим в десятичные числа
plot( decInputData ); % строим график
xlabel( 'Отсчеты' );
ylabel( 'Сигнал' );
title( 'Дискретный сигнал' );

% картинка 7

modData = pammod( decInputData, M ); % модулированный сигнал
scatterplot( modData ); % строим созвездие

% картинка 8

% моделируем передачи по каналу с переменным соотношением с/ш, считаем
% вероятности ошибок:
snrs = []'; % инициализируем векторы соотношения с/ш,
binErrors = []'; % количества битовых ошибок
binErrorProbabilities = []'; % и вероятностей возникновения битовых ошибок
decErrors = []'; % количества символьных ошибок
decErrorProbabilities = []'; % и вероятностей возникновения символьных ошибок
for snr = -60 : 5 : 60
    chanData = awgn( modData, snr ); % сигнал в канале передачи
    decResData = pamdemod( chanData, M ); % демодуляция сигнала
    binResData = de2bi( decResData ); % представляем битами
    % подсчет ошибок
    [ binErrors( end + 1 ), binErrorProbabilities( end + 1 ) ] = biterr( binInputData, binResData );
    [ decErrors( end + 1 ), decErrorProbabilities( end + 1 ) ] = symerr( decInputData, decResData );
    snrs( end + 1 ) = snr;
end
% строим графики
plot( snrs, binErrors )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Количество ошибок' );
title( 'Зависимость количества битовых ошибок от соотношения сигнал/шум при передаче амплитудноимпульсномодулированного сигнала' );

% картинка 9

plot( snrs, binErrorProbabilities )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Вероятность ошибки' );
title( 'Зависимость вероятности возникновения битовой ошибки от соотношения сигнал/шум' );

% картинка 10

plot( snrs, decErrors )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Количество ошибок' );
title( 'Зависимость количества символьных ошибок от соотношения сигнал/шум при передаче амплитудноимпульсномодулированного сигнала' );

% картинка 11

plot( snrs, decErrorProbabilities )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Вероятность ошибки' );
title( 'Зависимость вероятности возникновения символьной ошибки от соотношения сигнал/шум' );

% картинка 12


% Квадратурная модуляция
phase = pi / 4; % чтоб было поинтересней, добавим начальную фазу
modData = qammod( decInputData, M, phase ); % модулируем
scatterplot( modData ); % строим созвездие
grid on

% картинка 13

% моделируем то же для QAM:
snrs = []'; % инициализируем векторы соотношения с/ш,
binErrors = []'; % количества битовых ошибок
binErrorProbabilities = []'; % и вероятностей возникновения битовых ошибок
decErrors = []'; % количества символьных ошибок
decErrorProbabilities = []'; % и вероятностей возникновения символьных ошибок
for snr = -60 : 5 : 60
    chanData = awgn( modData, snr ); % сигнал в канале передачи
    decResData = qamdemod( chanData, M, phase ); % демодуляция сигнала
    binResData = de2bi( decResData ); % представляем битами
    % подсчет ошибок
    [ binErrors( end + 1 ), binErrorProbabilities( end + 1 ) ] = biterr( binInputData, binResData );
    [ decErrors( end + 1 ), decErrorProbabilities( end + 1 ) ] = symerr( decInputData, decResData );
    snrs( end + 1 ) = snr;
end
% строим графики
plot( snrs, binErrors )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Количество ошибок' );
title( 'Зависимость количества битовых ошибок от соотношения сигнал/шум при передаче QAM сигнала' );

% картинка 14

plot( snrs, binErrorProbabilities )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Вероятность ошибки' );
title( 'Зависимость вероятности возникновения битовой ошибки от соотношения сигнал/шум' );

% картинка 15

plot( snrs, decErrors )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Количество ошибок' );
title( 'Зависимость количества символьных ошибок от соотношения сигнал/шум при передаче QAM сигнала' );

% картинка 16

plot( snrs, decErrorProbabilities )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Вероятность ошибки' );
title( 'Зависимость вероятности возникновения символьной ошибки от соотношения сигнал/шум' );

% картинка 17


% амплитудная манипуляция методом топора

lengthOfBit = 20; % количество отчетов, которое будет длиться 1 символ
% сформируем сигнал из набора входных данных
sig = zeros( lengthOfBit * length( decInputData ), 1 ); % инициализируем массив нового сигнала
for i = 0 : length( decInputData ) - 1
    for j = 1 : lengthOfBit
        sig( i * lengthOfBit + j ) = decInputData( i + 1 ); % копируем данные
    end
end
modSig = ammod( sig, Fm, Fs, 0, Am ); % модулированный сигнал
errors = []'; % количество символьных ошибок
errorProbabilities = []'; % и вероятностей возникновения символьных ошибок
for snr = -60 : 5 : 60
    chanSig = awgn( modSig, snr ); % сигнал в канале передачи
    resSig = amdemod( chanSig, Fm, Fs, 0, Am ); % демодуляция сигнала
    % вернемся к представлению данных
    resData = zeros( length( decInputData ), 1 );
    j = 1;
    for i = 1 : lengthOfBit : length( resSig ) - lengthOfBit
        resData( j ) = round( mean( resSig( i : i + lengthOfBit ) ) ); % возьмем среднее из lengthOfBit отсчетов
        j = j + 1;
    end
    % подсчет ошибок
    [ errors( end + 1 ), errorProbabilities( end + 1 ) ] = symerr( decInputData, resData );
end
% строим графики
plot( snrs, errors )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Количество ошибок' );
title( 'Зависимость количества символьных ошибок от соотношения сигнал/шум при передаче ASK сигнала' );

% картинка 18

plot( snrs, errorProbabilities )
grid on
xlabel( 'SNR, дБ' );
ylabel( 'Вероятность возникновения ошибки' );
title( 'Зависимость вероятности возникновения символьных ошибок от соотношения сигнал/шум при передаче ASK сигнала' );

% картинка 19
