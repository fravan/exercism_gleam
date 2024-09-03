pub type Coach {
  Coach(name: String, former_player: Bool)
}

pub type Stats {
  Stats(wins: Int, losses: Int)
}

pub type Team {
  Team(name: String, coach: Coach, stats: Stats)
}

pub fn create_coach(name: String, former_player: Bool) -> Coach {
  Coach(name:, former_player:)
}

pub fn create_stats(wins: Int, losses: Int) -> Stats {
  Stats(wins:, losses:)
}

pub fn create_team(name: String, coach: Coach, stats: Stats) -> Team {
  Team(name:, coach:, stats:)
}

pub fn replace_coach(team: Team, coach: Coach) -> Team {
  Team(..team, coach:)
}

pub fn is_same_team(home_team: Team, away_team: Team) -> Bool {
  home_team == away_team
}

pub fn root_for_team(team: Team) -> Bool {
  root_for_coach(team.coach)
  || root_for_name(team.name)
  || root_for_stats(team.stats)
}

fn root_for_coach(coach: Coach) {
  coach.name == "Gregg Popovich" || coach.former_player
}

fn root_for_name(name: String) {
  name == "Chicago Bulls"
}

fn root_for_stats(stats: Stats) {
  stats.wins >= 60 || stats.losses > stats.wins
}
