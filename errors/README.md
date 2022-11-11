# Developing Robust Programs

## Data Testing

When testing numeric data, there are several corner cases you always need to test:

1. The number 0
2. The number 1
3. A number within the expected range
4. A number outside the expected range
5. The first number in the expected range
6. The last number in the expected range
7. The first number below the expected range
8. The first number above the expected range

For example, if I have a program that is supposed to accept values between 5 and 200, I should test 0, 1, 4, 5, 153, 200, 201, and 255 at a minimum (153 and 255 were randomly chosen inside and outside the range, respectively).
