// **********************************************************************
//
// Copyright (c) 2003-2005 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

public class Collocated
{
    public static int
    run(String[] args, Ice.Communicator communicator, java.io.PrintStream out)
    {
	//
	// For this test, we need a dummy logger, otherwise the
	// assertion test will print an error message.
	//
	communicator.setLogger(new DummyLogger());

	communicator.getProperties().setProperty("Test.Proxy", "thrower:default -p 12345 -t 10000"); 
        communicator.getProperties().setProperty("TestAdapter.Endpoints", "default -p 12345 -t 10000");
        Ice.ObjectAdapter adapter = communicator.createObjectAdapter("TestAdapter");
        Ice.Object object = new ThrowerI(adapter);
        adapter.add(object, Ice.Util.stringToIdentity("thrower"));
	adapter.activate();

        AllTests.allTests(communicator, out);

        return 0;
    }

    public static void
    main(String[] args)
    {
        int status = 0;
        Ice.Communicator communicator = null;

        try
        {
            communicator = Ice.Util.initialize(args);
            status = run(args, communicator, System.out);
        }
        catch(Ice.LocalException ex)
        {
            ex.printStackTrace();
            status = 1;
        }

        if(communicator != null)
        {
            try
            {
                communicator.destroy();
            }
            catch(Ice.LocalException ex)
            {
                ex.printStackTrace();
                status = 1;
            }
        }

        System.exit(status);
    }
}
