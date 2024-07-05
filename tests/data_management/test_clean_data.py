import numpy as np
import pandas as pd
import pytest
import yaml
from template_project.config import TESTS
from template_project.data_management.clean_data_template import clean_data


@pytest.fixture()
def data():
    return pd.read_csv(TESTS / "data_management" / "data_fixture.csv")


@pytest.fixture()
def data_info():
    with (TESTS / "data_management" / "data_info_fixture.yaml").open() as file:
        return yaml.safe_load(file)


def test_clean_data_drop_columns(data, data_info):
    data_clean = clean_data(data, data_info)
    assert not set(data_info["columns_to_drop"]).intersection(set(data_clean.columns))


def test_clean_data_dropna(data, data_info):
    data_clean = clean_data(data, data_info)
    assert not data_clean.isna().any(axis=None)


def test_clean_data_categorical_columns(data, data_info):
    data_clean = clean_data(data, data_info)
    for cat_col in data_info["categorical_columns"]:
        renamed_col = data_info["column_rename_mapping"].get(cat_col, cat_col)
        assert data_clean[renamed_col].dtype == "category"


def test_clean_data_column_rename(data, data_info):
    data_clean = clean_data(data, data_info)
    old_names = set(data_info["column_rename_mapping"].keys())
    new_names = set(data_info["column_rename_mapping"].values())
    assert not old_names.intersection(set(data_clean.columns))
    assert new_names.intersection(set(data_clean.columns)) == new_names


def test_convert_outcome_to_numerical(data, data_info):
    data_clean = clean_data(data, data_info)
    outcome_name = data_info["outcome"]
    outcome_numerical_name = data_info["outcome_numerical"]
    assert outcome_numerical_name in data_clean.columns
    assert data_clean[outcome_name].dtype == "category"
    assert data_clean[outcome_numerical_name].dtype == np.int8
