package io.armory.lambda.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

/***
 * hello world
 */
public class WelcomeLambda implements RequestHandler<Object, Object> {

    @Override
    public Object handleRequest(Object input, Context context) {
        System.out.println(input);
        return "hello world";
    }
}
