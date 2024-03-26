const serverEndpoint = '13.209.238.192:8080';
final apiPath = {
  'getTodos': (userId) => '/api/v1/todo/getByDate/$userId',
  'createTodo': (userId) => '/api/v1/todo/create/$userId',
  'deleteTodo': (userId, todoId) => '/api/v1/todo/delete/$userId/$todoId',
  'updateTodo': (userId, todoId) => '/api/v1/todo/update/$userId/$todoId',
  'getPreviews': (userId) => '/api/v1/routine/getPreviews/$userId',
  'getRoutines': (userId) => '/api/v1/routine/getByDate/$userId',
  'createPreview': (userId) => '/api/v1/routine/createPreview/$userId',
  'createRoutine': (userId, routineId) =>
      '/api/v1/routine/createRoutine/$userId/$routineId',
  'finishRoutine': (userId, routineId) =>
      '/api/v1/routine/finish/$userId/$routineId',
  'deleteRoutine': (userId, routineId) =>
      '/api/v1/routine/delete/$userId/$routineId',
  'updatePreview': (userId, routineId) =>
      '/api/v1/routine/update/$userId/$routineId',
  'verifyRoutine': (userId, routineId) =>
      '/api/v1/routine/verify/$userId/$routineId',
  'registerUser': () => '/api/v1/user/registration',
  'getMyFeeds': (userId) => '/api/v1/routine/getMyFeeds/$userId',
  'getAllFeeds': () => '/api/v1/routine/getAllFeeds'
};
