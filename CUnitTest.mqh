﻿//+------------------------------------------------------------------+
//|                                                        CUnitTest |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "1.0"

#include <Arrays\ArrayObj.mqh>
#include <mql5-lib\CTest.mqh>

//+------------------------------------------------------------------+
//| Unit test class                                                  |
//+------------------------------------------------------------------+
class CUnitTest
  {
protected:
   //--- sub tests array
   CArrayObj*        m_testArray;
   //--- unit test name
   string            m_name;
   //--- error state
   bool              m_error;

public:
   //--- constructor
                     CUnitTest(string);
   //--- destructor
                    ~CUnitTest();

   //--- get name
   string             name();

   //--- describe a sub test
   long               describe(CTest*);

   //--- test all
   bool               testAll();
   //--- test a given sub test
   bool               test(uint, double&);
   //--- test a given sub test overload
   bool               test(uint);
  };

//+------------------------------------------------------------------+
//| constructor                                                      |
//+------------------------------------------------------------------+
CUnitTest::CUnitTest(string t_name)
   : m_name(t_name)
  {
//--- set pointer
   m_testArray = new CArrayObj;
//--- test pointer
   if(m_testArray == NULL)
     {
      //--- set error
      m_error = true;
     }
  }
//+------------------------------------------------------------------+
//| destructor                                                       |
//+------------------------------------------------------------------+
CUnitTest::~CUnitTest()
  {
//--- delete test array
   delete m_testArray;
  }
//+------------------------------------------------------------------+
//| get name                                                         |
//+------------------------------------------------------------------+
string CUnitTest::name()
  {
//--- return name
   return m_name;
  }
//+------------------------------------------------------------------+
//| describe a sub test                                              |
//+------------------------------------------------------------------+
long               CUnitTest::describe(CTest* t_test)
  {
//--- push to array
   if(!m_testArray.Add(t_test))
     {
      //--- failed to add
      return -1;
     }
//--- return sub test id
   return m_testArray.Total();
  }
//+------------------------------------------------------------------+
//| test all                                                         |
//+------------------------------------------------------------------+
bool               CUnitTest::testAll()
  {
//--- store sub test index value
   int index = -1;
//--- flag if any subtest has failed
   bool anyHasFailed = false;
//--- store number of tests
   int totalTests = m_testArray.Total();
//--- echo
   Print("Testing ", m_name, " (", totalTests, " tests)");
//--- loop through sub tests
   while(index++ < totalTests)
     {
      //--- test exit code
      if(!test(index) && !anyHasFailed)
        {
         //--- set any has failed flag
         anyHasFailed = true;
        }
     }
//--- return if any of the sub tests has failed
   return anyHasFailed;
  }
//+------------------------------------------------------------------+
//| test                                                             |
//+------------------------------------------------------------------+
bool               CUnitTest::test(uint t_test_index)
  {
//--- store test pointer
   CTest* test = m_testArray.At(t_test_index);
//--- test pointer
   if(test == NULL)
     {
      //--- operation failed
      return false;
     }
//--- run test
   test.run();
//--- text if succeed
   if(test.exitCode() != CTEST_EXITCODE_SUCCESS)
     {
      //--- echo
      Print("    ✗ ", test.name(), " (", NormalizeDouble(test.duration() / 1000, 1), " ms) exited with code ", test.exitCode());
      //--- operation failed
      return false;
     }
//--- echo
   Print("    ✓ ", test.name(), " (", NormalizeDouble(test.duration() / 1000, 1), " ms)");
//--- return succeed
   return  true;
  }
//+------------------------------------------------------------------+
