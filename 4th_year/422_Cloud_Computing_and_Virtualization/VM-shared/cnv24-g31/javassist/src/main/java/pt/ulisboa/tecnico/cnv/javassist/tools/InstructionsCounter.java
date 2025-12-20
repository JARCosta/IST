package pt.ulisboa.tecnico.cnv.javassist.tools;

import java.util.List;

import javassist.CannotCompileException;
import javassist.CtBehavior;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import java.lang.Thread;

import java.lang.Long;

public class InstructionsCounter extends AbstractJavassistTool {

    /**
     * Number of executed instructions.
     */
    private static Map<Long, Long> inst_count = new ConcurrentHashMap<>();

    public InstructionsCounter(List<String> packageNameList, String writeDestination) {
        super(packageNameList, writeDestination);
    }

    public static void incBasicBlock(int length, long threadId) {
        inst_count.put(threadId, inst_count.getOrDefault(threadId, 0L) + length);
    }

    public static Long getInstructionsCount(long threadId) {
        Long temp = inst_count.getOrDefault(threadId, 0L);
        inst_count.put(threadId, 0L);
        return temp;
    }

    public static void printStatistics(long threadId) {
        System.out.println(String.format("[%s] Number of executed instructions: %s", InstructionsCounter.class.getSimpleName(), inst_count.getOrDefault(threadId, 0L)));
        inst_count.put(threadId, 0L);
    }

    @Override
    protected void transform(BasicBlock block) throws CannotCompileException {

        super.transform(block);
        block.behavior.insertBefore(String.format("%s.incBasicBlock(%s, Thread.currentThread().getId());", InstructionsCounter.class.getName(), block.getLength()));
    }

}
