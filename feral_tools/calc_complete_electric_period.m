function [Vec] = calc_complete_electric_period(Vec, Skew)

Skew.RotorPositions = Skew.RotorPositions ;
Skew.Ia(thm) = ia;
Skew.Ib(thm) = ib;
Skew.Ic(thm) = ic;
Skew.CurrentInSlot(thm,:,sk) = CurrentInSlot;
Skew.FluxA(sk,thm) = FluxABC(1);
Skew.FluxB(sk,thm) = FluxABC(2);
Skew.FluxC(sk,thm) = FluxABC(3);
Skew.FluxD(sk,thm) = FluxD;
Skew.FluxQ(sk,thm) = FluxQ;
Skew.TorqueMXW(sk,thm) = TorqueMXW;
Skew.TorqueDQ(sk,thm) = TorqueDQ;
Skew.ForceX(sk,thm) = ForceX;
Skew.ForceY(sk,thm) = ForceY;
Skew.Energy(sk,thm) = Energy;
Skew.Coenergy(sk,thm) = Coenergy;
Skew.IntegralAJ(sk,thm) = AJint;
Skew.MaxFluxDensityTeeth(sk,thm) = MaxFluxDensityTeeth;
Skew.MaxFluxDensityYoke(sk,thm) = MaxFluxDensityYoke;
Skew.AirgapFluxDensity(thm,:,sk_Bg) = AirgapFluxDensity;


% Compute the skewed arrays
Vec.RotorPositions      = Skew.RotorPositions;
Vec.Ia                  = Skew.Ia;
Vec.Ib                  = Skew.Ib;
Vec.Ic                  = Skew.Ic;
Vec.FluxA               = mean(Skew.FluxA);
Vec.FluxB               = mean(Skew.FluxB);
Vec.FluxC               = mean(Skew.FluxC);
Vec.FluxD               = mean(Skew.FluxD);
Vec.FluxQ               = mean(Skew.FluxQ);
Vec.TorqueMXW           = mean(Skew.TorqueMXW);
Vec.TorqueDQ            = mean(Skew.TorqueDQ);
Vec.ForceX              = max(Skew.ForceX);
Vec.ForceY              = max(Skew.ForceY);
Vec.Energy              = mean(Skew.Energy);
Vec.Coenergy            = mean(Skew.Coenergy);
Vec.IntegralAJ          = mean(Skew.IntegralAJ);
Vec.MaxFluxDensityTeeth = max(Skew.MaxFluxDensityTeeth);
Vec.MaxFluxDensityYoke  = max(Skew.MaxFluxDensityYoke);
Vec.AirgapFluxDensity   = Skew.AirgapFluxDensity;



Vec.FluxA = [Vec.FluxA, -Vec.FluxB, Vec.FluxC]; 
Vec.FluxB = [Vec.FluxB, -Vec.FluxC, Vec.FluxA]; 
Vec.FluxC = [Vec.FluxC, -Vec.FluxA, Vec.FluxB]; 

Vec.FluxA = [Vec.FluxA, -Vec.FluxA];
Vec.FluxB = [Vec.FluxB, -Vec.FluxB];
Vec.FluxC = [Vec.FluxC, -Vec.FluxC];


Vec.FluxD = repmat(Vec.FluxD, 1, 6)
Vec.FluxQ = repmat(Vec.FluxQ, 1, 6)

end