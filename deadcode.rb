behaviors.behavior, behaviors.targeted_for
FROM assigned_behaviors
INNER JOIN behaviors
  ON assigned_behaviors.behavior_id = behaviors.id

    'targeted_for' => result['targeted_for'],
