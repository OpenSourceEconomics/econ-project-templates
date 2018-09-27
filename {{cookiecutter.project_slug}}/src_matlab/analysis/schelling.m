%{
Run a Schelling (1969) segregation model and store a database with locations 
and types at each cycle. The scripts expects a model name to be passed on 
the command line that needs to correspond to a file called [model_name].json 
in the "IN_MODEL_SPECS" directory. The model name is then recovered form the 
command line and made available through the matlab variable named "append".
%}
function schelling(model_name)

% Add path to relevant model code
addpath ../model_code/

% Add path to matlab-json parser
addpath ../library/matlab-json/
json.startup

% Load random sample with initial locations
load(project_paths('OUT_DATA', 'sample.mat'));


% Load model specifications
model = json.read(project_paths('IN_MODEL_SPECS', [model_name, '.json']));

% Set random seed
rng(model.rng_seed, 'twister');

% Initilize type-1 agents' locations
agents = [ ...
    sample(1 : model.n_agents_by_type(1), :, 1), ...
    ones(model.n_agents_by_type(1), 1) ...
];

% Initilize all other types' locations
for i = 2 : model.n_types;
    n = model.n_agents_by_type(i);
    % Obtain agents' initial locations and types from sample.
    agents_by_type = [sample(1 : n, :, i), i*ones(n, 1)];
    agents = [agents; agents_by_type];
end

% Initilize placeholder for locations by round.
locations_by_round = NaN*zeros(size(agents, 1), 3, model.max_iterations);

% First round is agents' initial location subject to updating procedure below
locations_by_round( :, :, 1) = agents;
n_rounds = 1;

for loop_counter = 2 : model.max_iterations;
    
    locations_by_round( :, :, loop_counter) = ( ...
        locations_by_round( :, :, loop_counter - 1) ...
    );
    
    someone_moved = 0;
    for a = 1 : size(agents, 1); % Loop through agents
                
        % Obtain this agent's current location
        old_location = locations_by_round(a, :, loop_counter);
        
        % Obtain all other agents' current locations
        other_agents = locations_by_round( :, :, loop_counter);
        other_agents(a, :) = [];
                
        % Obtain this agent's new location conditioned on his happiness
        new_location = move_until_happy(...
            old_location, ...
            other_agents, ...
            model.n_neighbours, ...
            model.require_same_type, ...
            model.max_moves ...
        );
        
        % Check if this agent moved
        if (new_location(1 : 2) ~= old_location(1 : 2));
            someone_moved = 1;
            n_rounds = loop_counter;
        end
        
        % Update this agent's location
        locations_by_round(a, :, loop_counter) = new_location;
    end
    
    % We are done if everybody is happy
    if someone_moved == 0;
        break;
    end
end

% Not everybody has reached happiness
if someone_moved == 1;
    disp(['No convergence achieved after ', int2str(model.max_iterations), ' iterations.'])
end

locations_by_round = locations_by_round( :, :, (1 : n_rounds));
save(project_paths('OUT_ANALYSIS', ['schelling_', model_name , '.mat']), 'locations_by_round');   