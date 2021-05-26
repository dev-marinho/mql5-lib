//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_TICK_RESET__
#define __C_TICK_RESET__

#include <Indicators\Trend.mqh>
#include "CStrategy.mqh"
#include "CInterface.mqh"

input int            TICK_RESET = 4;
input bool           REVERSE_DECISION = false;
input double M = 0.5;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TickReset : public CStrategy
  {
private:
   CInterface        Interface;
   double            tick_score;

   inline void        Strategy()
     {
      double spread = (Round.Ask() - Round.Bid())  / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      if(spread <= 5)
        {
         if(tick_score >= TICK_RESET)
            Round.OpenOrder(REVERSE_DECISION ? true : false, VOLUMES, TP_TICK, SL_TICK);
         else
            if(tick_score <= -TICK_RESET)
               Round.OpenOrder(REVERSE_DECISION ? false : true, VOLUMES, TP_TICK, SL_TICK);
        }
     }

   void              OnInit()
     {
      Interface.AddLabel("Campaign");
      Interface.AddLabel("Total", "0.0");
      Interface.AddLabel("Earns", "0.0");
      Interface.AddLabel("Fees", "0.0");
      Interface.AddLabel("Rounds", "0");
      Interface.AddLabel("Highest Profit", "0.0");
      Interface.AddLabel("Lowest Profit", "0.0");
      Interface.AddLabel("Start Time", "--:--:--");
      Interface.AddLabel("Actual Time", "--:--:--");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Round");
      Interface.AddLabel("Profit", "0.0");
      Interface.AddLabel("Price", "0.0");
      Interface.AddLabel("Ask", "0.0");
      Interface.AddLabel("Bid", "0.0");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Strategy");
      Interface.AddLabel("Score", "0");
      Interface.AddLabel("Rate", "0.0");
     }

   inline void       OnRoundInit(void)
     {
      Round.SetExpertMagicNumber(4444);
      Round.SetDeviationInPoints(0);
      Round.SetTypeFilling(ORDER_FILLING_FOK);
      Round.SetMarginMode();
      Round.LogLevel(0);
      Interface.SetLabelData(State(), 9);
     }

   inline void       OnTick()
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 8);
     }

   inline void       OnValidTick()
     {
      tick_score += Round.PriceChange() / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * M;

      if(MathAbs(tick_score) > TICK_RESET / M)
         tick_score = 0;

      Interface.SetLabelData(State(), 9);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Price(), 2), 13);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Ask(), 2), 14);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Bid(), 2), 15);
      Interface.SetLabelData(Round.State(), 16);
      Interface.SetLabelData(DoubleToString(tick_score ,2), 19);
     }

   inline void       OnFirstIdleTick(void)
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 7);
     }

   inline void       OnIdleTick(void)
     {
      Strategy();
     }

   inline void       OnPositionTick(void)
     {
      Round.ResolveClose();
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
     }

   inline void       OnDealTick(void)
     {
      Interface.SetLabelData("R$ " + DoubleToString(Total(), 2), 1);
      Interface.SetLabelData("R$ " + DoubleToString(Earns(), 2), 2);
      Interface.SetLabelData("R$ " + DoubleToString(Fees(), 2), 3);
      Interface.SetLabelData(Rounds(), 4);
      Interface.SetLabelData("R$ " + DoubleToString(HighestProfit(), 2), 5);
      Interface.SetLabelData("R$ " + DoubleToString(LowestProfit(), 2), 6);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
      Interface.SetLabelData(tick_score, 19);
      Interface.SetLabelData(DoubleToString(ProfitRounds() / (double)Rounds() * 100, 2) + "%", 20);
     }
  };
#endif
//+------------------------------------------------------------------+
