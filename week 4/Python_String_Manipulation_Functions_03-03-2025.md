**📌 Python String Manipulation Functions**

**1️. remove_outermost_parenthesis(s)**

**🔹 Purpose:**

Removes the **outermost parentheses** from a valid parenthesis string.

**🔹 Why This Approach?**

-   Instead of using a stack (which requires extra space), we use a
    **counting method** (open_count).

-   This allows us to determine when parentheses are at the outermost
    level and avoid adding them.

**🔹 How It Works:**

1.  **Track opening brackets count (open_count)**.

2.  **Append characters to result\[\] only if they are not outermost**:

    -   If char == \'(\' and open_count \> 0, add it (to skip the first
        ().

    -   If char == \')\' and open_count \> 1, add it (to skip the last
        )).

3.  **Modify open_count**:

    -   Increment for (.

    -   Decrement for ).

**🔹 Time Complexity:**

-   **O(n)** - We iterate through the string once (n is the length of
    s).

-   **O(n) space** - We store the modified string in a list.

**🔹 Code:**

def remove_outermost_parenthesis(s):

result = \[\]

open_count = 0

for char in s:

if char == \'(\' and open_count \> 0:

result.append(char)

elif char == \')\' and open_count \> 1:

result.append(char)

if char == \'(\':

open_count += 1

elif char == \')\':

open_count -= 1

return \'\'.join(result)

**🔹 Example Usage:**

print(remove_outermost_parenthesis(\"(()())\")) \# Output: \"()()\"

**2️. reverse_words(s)**

**🔹 Purpose:**

Reverses the order of words in a string.

**🔹 Why This Approach?**

-   Instead of manually splitting and reversing words using a loop, we
    use Python\'s **split()** and **list slicing** (\[::-1\]), which is
    more efficient.

**🔹 How It Works:**

1.  **Split the string** into words using .split() (splits on
    whitespace).

2.  **Remove empty strings** (if any extra spaces exist).

3.  **Reverse the list of words** using \[::-1\].

4.  **Join the reversed list back** into a string using \' \'.join().

**🔹 Time Complexity:**

-   **O(n)** - We iterate over the string **once** for splitting,
    reversing, and joining.

**🔹 Code:**

def reverse_words(s):

words = \[word for word in s.split() if word\]

return \' \'.join(words\[::-1\])

**🔹 Example Usage:**

print(reverse_words(\"my name is PK\")) \# Output: \"PK is name my\"

**3️. largest_odd_number(s)**

**🔹 Purpose:**

Finds the **largest odd number** that can be formed by trimming digits
from the end.

**🔹 Why This Approach?**

-   Instead of checking all possible numbers, we **scan from right to
    left** and return the substring as soon as we find an odd digit.

**🔹 How It Works:**

1.  **Iterate from the last digit** to the first (range(len(s) - 1, -1,
    -1)).

2.  If **digit is odd (int(s\[i\]) % 2 == 1)**, return s\[:i+1\].

3.  If no odd digit is found, return an **empty string**.

**🔹 Time Complexity:**

-   **O(n)** - In the worst case, we scan the entire string once.

**🔹 Code:**

def largest_odd_number(s):

for i in range(len(s)-1, -1, -1):

if int(s\[i\]) % 2 == 1:

return s\[:i+1\]

return \"\"

**🔹 Example Usage:**

print(largest_odd_number(\"354270\")) \# Output: \"35427\"

print(largest_odd_number(\"24680\")) \# Output: \"\"

**4️. longest_common_substring(words)**

**🔹 Purpose:**

Finds the **longest substring** that is common across all words.

**🔹 Why This Approach?**

-   Instead of checking all possible substrings, we **start with the
    shortest word** and test substrings from it. This reduces
    unnecessary comparisons.

**🔹 Time Complexity:**

-   **O(n \* m²)**, where:

    -   n is the number of words.

    -   m is the length of the shortest word.

**🔹 Code:**

def longest_common_substring(words):

if not words:

return \"\"

shortest = min(words, key=len)

longest_substr = \"\"

for i in range(len(shortest)):

for j in range(i + 1, len(shortest) + 1):

substr = shortest\[i:j\]

if all(substr in word for word in words):

if len(substr) \> len(longest_substr):

longest_substr = substr

else:

break

return longest_substr

**🔹 Example Usage:**

words = \[\"flight\", \"lightning\", \"slight\"\]

print(longest_common_substring(words)) \# Output: \"light\"

**5️. are_rotations(s1, s2)**

**🔹 Purpose:**

Checks if two strings are **rotations of each other**.

**🔹 Why This Approach?**

-   Instead of manually rotating the string, we **concatenate s1 + s1**
    and check if s2 exists inside.

**🔹 Time Complexity:**

-   **O(n)** - String concatenation and substring search are linear.

**🔹 Code:**

def are_rotations(s1, s2):

if len(s1) != len(s2):

return False

return s2 in (s1 + s1)

**🔹 Example Usage:**

print(are_rotations(\"abcd\", \"cdab\")) \# Output: True

print(are_rotations(\"abcd\", \"cdba\")) \# Output: False

**6️. is_anagram(s1, s2)**

**🔹 Purpose:**

Checks if two words are **anagrams**.

**🔹 Why This Approach?**

-   We use **character frequency counting** instead of sorting (O(n log
    n)), making it **faster**.

**🔹 Time Complexity:**

-   **O(n)** - Counting characters and comparing dictionaries.

**🔹 Code:**

def is_anagram(s1, s2):

if len(s1) != len(s2):

return False

char_count_s1 = {}

char_count_s2 = {}

for char in s1:

char_count_s1\[char\] = char_count_s1.get(char, 0) + 1

for char in s2:

char_count_s2\[char\] = char_count_s2.get(char, 0) + 1

return char_count_s1 == char_count_s2

**🔹 Example Usage:**

print(is_anagram(\"listen\", \"silent\")) \# Output: True

print(is_anagram(\"hello\", \"world\")) \# Output: False

**✅ Final Takeaway**

  -----------------------------------------------------------------------------
  **Function**                     **Approach**   **Time         **Space
                                                  Complexity**   Complexity**
  -------------------------------- -------------- -------------- --------------
  remove_outermost_parenthesis()   Counting ( )   **O(n)**       **O(n)**

  reverse_words()                  Splitting &    **O(n)**       **O(n)**
                                   reversing                     

  largest_odd_number()             Scanning from  **O(n)**       **O(1)**
                                   right                         

  longest_common_substring()       Brute-force    **O(n \* m²)** **O(1)**

  are_rotations()                  s1 + s1 trick  **O(n)**       **O(n)**

  is_anagram()                     Frequency      **O(n)**       **O(1)**
                                   dictionary                    
  -----------------------------------------------------------------------------
