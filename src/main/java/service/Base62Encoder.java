package service;

public class Base62Encoder {
    private static final char[] ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
    public static String encode(long value) {
        if (value == 0) return "a";
        StringBuilder sb = new StringBuilder();
        while (value > 0) {
            int idx = (int)(value % 62);
            sb.append(ALPHABET[idx]);
            value /= 62;
        }
        return sb.reverse().toString();
    }
}

