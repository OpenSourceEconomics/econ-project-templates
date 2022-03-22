"""Module containing functions for a Monte Carlo simulation.

Note: Data generating code is written but no Monte Carlo simulation function.

"""
import numpy as np
import pandas as pd


def generate_logit_data(n_features, n_samples, seed=0):
    """Generate data using a Logit model.
    
    Args:
        n_features (int): Number of features/covariates.
        n_samples (int): Number of observations.
        seed (int): Random number generator seed.
        
    Returns:
        - pandas.DataFrame: The simulated model.
        - numpy.ndarray: True model coefficients.
    
    """
    np.random.seed(seed)

    coef = _create_coefs(n_features)
    x = _simulate_features(n_features, n_samples)
    true_probs = _simulate_true_probs(x, coef)
    y = _simulate_response(true_probs)
    
    data = pd.DataFrame(x)
    data["outcome"] = y

    return data, coef


def _simulate_features(n_samples, n_features):
    x = np.random.normal(size=(n_samples, n_features))
    return x


def _create_coefs(n_features):
    coef = 1.0 + np.arange(n_features)  # slopes
    coef = np.insert(coef, 0, -1)  # intercept
    return coef


def _linear_model_part(x, coef):
    linear_part = coef[0] + x @ coef[1:]
    return linear_part


def _logistic_function(u):
    return 1 / (1 + np.exp(-u))


def _simulate_true_probs(x, coef):
    lm_part = _linear_model_part(x, coef)
    prob = _logistic_function(lm_part)
    return prob


def _simulate_response(prob):
    y = np.random.binomial(1, prob)
    return y
