const serverEndpoint = 'www.picle.server.com';
final apiPath = {
  'getPreviews': (userId) => '/api/v1/routine/getPreviews/$userId',
  'getRoutines': (userId) => '/api/v1/routine/getByDate/$userId',
  'createPreview': (userId) => '/api/v1/routine/createPreview/$userId',
  'createRoutine': (userId, routineId) =>
      '/api/v1/routine/createRoutine/$userId/$routineId',
};
