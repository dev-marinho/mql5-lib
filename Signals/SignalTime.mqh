//+------------------------------------------------------------------+
//|                                                   SignalTime.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL_TIME__
#define __C__SIGNAL_TIME__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Signals/Signal.mqh>
//+------------------------------------------------------------------+
//| Defines                                                          |
//+------------------------------------------------------------------+
#define EXPERT_SIGNAL_TIME_24_HOURS_IN_SECONDS 86400
//+------------------------------------------------------------------+
//| An expert signal based on time range                             |
//+------------------------------------------------------------------+
class CSignalTime : public CSignal
{
protected:
  bool m_conditional_result; // store conditional result
  int m_time_start_seconds;  // start time seconds
  int m_time_end_seconds;    // end time seconds

  //--- methods for resolve time is between range
  bool IsTimeBetweenRange(int t_time);

  //--- methods for manipulate string time
  int CalculateTimeSecondsFromDateTime(datetime);
  int CalculateSecondsFromTime(string);

public:
  CSignalTime(string, string);
  //--- method to write condition
  virtual bool CheckConditional(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalTime::CSignalTime(string t_time_start, string t_time_end = "")
    : m_conditional_result(false),
      m_time_start_seconds(CalculateSecondsFromTime(t_time_start)),
      m_time_end_seconds(t_time_end == "" ? m_time_start_seconds : CalculateSecondsFromTime(t_time_end))
{
}
//+------------------------------------------------------------------+
//| Test if given value is between time range                        |
//+------------------------------------------------------------------+
bool CSignalTime::IsTimeBetweenRange(int t_time_seconds)
{
  // Print(t_time_seconds + " >= " + m_time_start_seconds + " && " + t_time_seconds + " <= " + m_time_end_seconds);
  return t_time_seconds >= m_time_start_seconds && t_time_seconds <= m_time_end_seconds;
}
//+------------------------------------------------------------------+
//| Returns time seconds from a datetime                             |
//+------------------------------------------------------------------+
int CSignalTime::CalculateTimeSecondsFromDateTime(datetime t_datetime)
{
  return (int)(t_datetime % EXPERT_SIGNAL_TIME_24_HOURS_IN_SECONDS);
}
//+------------------------------------------------------------------+
//| Returns seconds from time string                           |
//+------------------------------------------------------------------+
int CSignalTime::CalculateSecondsFromTime(string t_time)
{
  if (!((StringLen(t_time) == 5 || StringFind(t_time, ":") == 1) || (StringLen(t_time) == 8 && StringFind(t_time, ":") == 2)))
    return false;

  int hour = (int)StringToInteger(StringSubstr(t_time, 0, 2));
  int minute = (int)StringToInteger(StringSubstr(t_time, 3, 2));
  int seconds = 0;
  if (StringFind(t_time, ":") == 2)
    seconds = (int)StringToInteger(StringSubstr(t_time, 6, 2));

  return (hour * 60 * 60) + (minute * 60) + seconds;
}
//+------------------------------------------------------------------+
//| Conditional to be tested                                         |
//+------------------------------------------------------------------+
bool CSignalTime::CheckConditional()
{
  return IsTimeBetweenRange(CalculateTimeSecondsFromDateTime(TimeTradeServer()));
}
#endif
//+------------------------------------------------------------------+