A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

# Running the server
this is neccessary to get redis running
```
docker-compose up -d 
```

Running our shelf server after our docker is activated

```dart
dart run bin/server.dart
```
<br />

#### Enpoints

<pre> 1. /auth/login: logs user in and gets authentication token for other features.</pre>

<pre> 2. /auth/register: registers users information on the users database and maps it the user types.</pre>
<pre> 3. /auth/logout: invalidates tokens already generated for the user.</pre>
<pre> 4. /auth/refreshtpoken: refreshes user token.</pre>
<pre> 5. /update/1: updates student informations.</pre>
<pre> 6. /update/2: updates guardian informations.</pre>
<pre> 7. /update/3: updates teachers informations.</pre>

<br />

#### Upcoming
1. Upload students course.
2. Assign teachers to students.
3. Manage student's grade.
4. manage guardian's communication system.


