class Solution(object):
    def lengthOfLastWord(self, s):
        i = len(s) - 1
        length = 0

        # Skip trailing spaces
        while i >= 0 and s[i] == ' ':
            i -= 1

        # Count last word length
        while i >= 0 and s[i] != ' ':
            length += 1
            i -= 1

        return length