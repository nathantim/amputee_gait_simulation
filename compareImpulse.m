%load data
reflexDataOn   = load('ReflexControl/impulseData.mat');
reflexDataOff  = load('ReflexControl/impulseDataOff.mat');
impDataOn  = load('ImpedanceControl/impulseData.mat');
impDataOff = load('ImpedanceControl/impulseDataOff.mat');

reflexBallPosOn = reflexDataOn.RBallPos.signals.values;
reflexBallPosOff = reflexDataOff.RBallPos.signals.values;

impBallPosOn  = impDataOn.RBallPos.signals.values;
impBallPosOff = impDataOff.RBallPos.signals.values;

reflexTorqueOn = reflexDataOn.kneeData.signals(2).values(:,2);
reflexTorqueOff = reflexDataOff.kneeData.signals(2).values(:,2);

impTorqueOn  = impDataOn.kneeData.signals(2).values(:,2);
impTorqueOff = impDataOff.kneeData.signals(2).values(:,2);

reflexAngleOn = reflexDataOn.kneeData.signals(1).values;
reflexAngleOff = reflexDataOff.kneeData.signals(1).values;

impAngleOn  = impDataOn.kneeData.signals(1).values;
impAngleOff = impDataOff.kneeData.signals(1).values;

%set times
tbuf = 0.1;
reflexT0 = 4.76;
reflexT1 = 5.23;
impT0 = 4.44;
impT1 = 4.95;

refImpulseT = reflexT0 + 0.05*(reflexT1 - reflexT0);
impImpulseT = impT0 + 0.05*(impT1 - impT0);

reflexTimeOn = reflexDataOn.RBallPos.time;
reflexTimeOff = reflexDataOff.RBallPos.time;

impTimeOn = impDataOn.RBallPos.time;
impTimeOff = impDataOff.RBallPos.time;

%crop to one timestep
reflexBallPosOn = reflexBallPosOn(reflexTimeOn > (reflexT0 - tbuf) ...
                                  & reflexTimeOn < (reflexT1 + tbuf),:);
reflexBallPosOff = reflexBallPosOff(reflexTimeOff > (reflexT0 - tbuf) ...
                                  & reflexTimeOff < (reflexT1 + tbuf),:);
reflexBallPosOn(:,1)  = reflexBallPosOn(:,1)  - reflexBallPosOn(1,1);
reflexBallPosOff(:,1) = reflexBallPosOff(:,1) - reflexBallPosOff(1,1);


impBallPosOn = impBallPosOn(impTimeOn > (impT0 - tbuf) ...
                                  & impTimeOn < (impT1 + tbuf),:);
impBallPosOff = impBallPosOff(impTimeOff > (impT0 - tbuf) ...
                                  & impTimeOff < (impT1 + tbuf),:);
impBallPosOn(:,1)  = impBallPosOn(:,1)  - impBallPosOn(1,1);
impBallPosOff(:,1) = impBallPosOff(:,1) - impBallPosOff(1,1);


reflexTorqueOn = reflexTorqueOn(reflexTimeOn > (reflexT0 - tbuf) ...
                                  & reflexTimeOn < (reflexT1 + tbuf));
reflexTorqueOff = reflexTorqueOff(reflexTimeOff > (reflexT0 - tbuf) ...
                                  & reflexTimeOff < (reflexT1 + tbuf));

impTorqueOn = impTorqueOn(impTimeOn > (impT0 - tbuf) ...
                                  & impTimeOn < (impT1 + tbuf));
impTorqueOff = impTorqueOff(impTimeOff > (impT0 - tbuf) ...
                                  & impTimeOff < (impT1 + tbuf));


reflexAngleOn = reflexAngleOn(reflexTimeOn > (reflexT0 - tbuf) ...
                                  & reflexTimeOn < (reflexT1 + tbuf));
reflexAngleOff = reflexAngleOff(reflexTimeOff > (reflexT0 - tbuf) ...
                                  & reflexTimeOff < (reflexT1 + tbuf));

impAngleOn = impAngleOn(impTimeOn > (impT0 - tbuf) ...
                                  & impTimeOn < (impT1 + tbuf));
impAngleOff = impAngleOff(impTimeOff > (impT0 - tbuf) ...
                                  & impTimeOff < (impT1 + tbuf));

subplot(221);
    plot(reflexBallPosOn(:,1),reflexBallPosOn(:,3))
    hold all
    plot(reflexBallPosOff(:,1),reflexBallPosOff(:,3),'--')
    hold off

subplot(222);
    plot(impBallPosOn(:,1),impBallPosOn(:,3))
    hold all
    plot(impBallPosOff(:,1),impBallPosOff(:,3),'--')
    hold off

subplot(223);
    plot(reflexAngleOn*180/pi,reflexTorqueOn)
    hold all
    plot(reflexAngleOff*180/pi,reflexTorqueOff,'--')
    hold off

subplot(224);
    plot(impAngleOn*180/pi,impTorqueOn)
    hold all
    plot(impAngleOff*180/pi,impTorqueOff,'--')
    hold off
