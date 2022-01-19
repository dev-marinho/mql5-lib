//+------------------------------------------------------------------+
//|                                                       Signal.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL__
#define __C__SIGNAL__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Routine.mqh>
//+------------------------------------------------------------------+
//| A signal class that trigger at given conditions                  |
//+------------------------------------------------------------------+
class CSignal : public CRoutine
{
protected:
   //--- identification property
   string m_name;

public:
   CSignal(string);

   //--- methods to access properties
   string Name(void) { return m_name; }

   //--- method to write condition
   virtual bool CheckConditional(void) { return false; }
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignal::CSignal(string t_name = "")
    : m_name(t_name)
{
}
#endif
//+------------------------------------------------------------------+